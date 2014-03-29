module.exports = (grunt) ->
  grunt.initConfig
    pkg : grunt.file.readJSON "package.json"
    tvm_tsc :
      build :
        options :
          version : "0.9.7"
          sourceMap : true
          declaration : true
        files :
          "compiled/compiled.js" : "src/index.ts"
      test :
        options :
          version : "0.9.7"
        files :
          "compiled/test.compiled.js" : "test/index.ts"

    browserify:
      test:
        src: ["harness/test.browser.js"]
        dest: "compiled/test.browserify.js"

    bower_concat:
      test:
        dest: "compiled/test.bower.concat.js"
        exclude: ["mocha", "sinon"]

    concat:
      test_browser:
        src: ["compiled/test.bower.concat.js", "compiled/test.browserify.js"]
        dest: "compiled/test.browser.js"
        options:
          separator: ";"

    testem :
      options : grunt.file.readYAML "testem.yml"
      browser :
        src: ["compiled/test.browser.js"]
        options:
          reporter: "tap"
          launch_in_ci: ["Chrome", "Firefox", "Safari", "IE", "PhantomJS", "Chromium"]
          launch_in_dev: ["Chrome", "Firefox", "Safari", "IE", "PhantomJS", "Chromium"]
      node:
        src: ["compiled/test.compiled.js"]
        options:
          reporter: "tap"
          launch_in_ci: ["Mocha"]
          launch_in_dev: ["Mocha"]

    clean :
      build :
        src : ["compiled/compiled.*"]
      test :
        src : ["compiled/test.*"]

    watch :
      build :
        files : ["src/**/*.ts"]
        tasks : ["default"]
      test :
        files : ["test/**/*.ts"]
        tasks : ["clean:test", "compile:test", "test"]
      config :
        files : ["Gruntfile.*", "*.json", ".*.yml", "*.yaml"]
        tasks : ["default"]
        options :
          reload : true

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-tvm-tsc"
  grunt.loadNpmTasks "grunt-browserify"
  grunt.loadNpmTasks "grunt-bower-concat"
  grunt.loadNpmTasks "grunt-contrib-concat"
  grunt.loadNpmTasks "grunt-contrib-testem"

  grunt.registerTask "default", ["clean", "compile:test", "test", "compile:build"]
  grunt.registerTask "compile", ["compile:test", "compile:build"]
  grunt.registerTask "compile:build", ["tvm_tsc:build"]
  grunt.registerTask "compile:test", ["compile:test:node", "compile:test:browser"]
  grunt.registerTask "compile:test:node", ["tvm_tsc:test"]
  grunt.registerTask "compile:test:browser", ["tvm_tsc:test", "browserify:test", "bower_concat:test", "concat:test_browser"]
  grunt.registerTask "test", ["test:testem"]
  grunt.registerTask "test:testem", ["test:node", "test:browser"]
  grunt.registerTask "test:node", ["testem:ci:node"]
  grunt.registerTask "test:browser", ["testem:ci:browser"]
  grunt.registerTask "test:travis", ["test:node"]