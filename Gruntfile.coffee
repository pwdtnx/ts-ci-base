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
          "compiled/test.js" : "test/index.ts"

    testem :
      options : grunt.file.readYAML "testem.yml"
      test :
        src: ["compiled/test.js"]
      travis:
        src: ["compiled/test.js"]
        options:
          launch_in_ci: ["PhantomJS", "Mocha"]
          launch_in_dev: ["PhantomJS", "Mocha"]

    "mocha-chai-sinon" :
      travis :
        src : ["test.js"]
        options :
          ui : "bdd"
          reporter : "spec"

      coverage :
        src : ["test.js"]
        options :
          ui : "bdd"
          reporter : "html-cov"
          quiet : true
          filter : "compiled"
          captureFile : "compiled/test.coverage.html"

    clean :
      build :
        src : ["compiled/compiled.*"]
      test :
        src : ["compiled/test.*"]

    watch :
      build :
        files : ["src/**/*.ts"]
        tasks : ["compile:test", "test", "compile:build"]
      test :
        files : ["test/**/*.ts"]
        tasks : ["compile:test", "test"]
      config :
        files : ["Gruntfile.*", "*.json", ".*.yml", "*.yaml"]
        tasks : ["default"]
        options :
          reload : true

  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-tvm-tsc"
  grunt.loadNpmTasks "grunt-contrib-testem"
  grunt.loadNpmTasks "grunt-mocha-chai-sinon"

  grunt.registerTask "default", ["compile:test", "test:testem", "compile:build"]
  grunt.registerTask "compile", ["compile:build", "compile:test"]
  grunt.registerTask "compile:build", ["clean:build", "tvm_tsc:build"]
  grunt.registerTask "compile:test", ["clean:test", "tvm_tsc:test"]
  grunt.registerTask "test", ["test:testem"]
  grunt.registerTask "test:testem", ["testem:ci:test", "mocha-chai-sinon:coverage"]
  grunt.registerTask "test:travis", ["testem:ci:travis"]