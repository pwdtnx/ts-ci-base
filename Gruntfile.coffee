module.exports = (grunt) ->
    grunt.initConfig
        pkg: grunt.file.readJSON "package.json"
        tvm_tsc:
            build:
                options:
                    version: "0.9.7"
                    sourceMap: true
                    declaration: true
                files:
                    "compiled/compiled.js": "src/index.ts"
            test:
                options:
                    version: "0.9.7"
                files:
                    "test.js": "test/index.ts"

        testem:
            test: grunt.file.readJSON "testem.json"


        "mocha-chai-sinon":
            travis:
                src: ["test.js"]
                options:
                    ui: "bdd"
                    reporter: "spec"

            coverage:
                src: ["test.js"]
                options:
                    ui: "bdd"
                    reporter: "html-cov"
                    quiet: true
                    filter: "compiled"
                    captureFile: "coverage.html"

        clean:
            build:
                src: ["compiled/**/*"]
            test:
                src: ["test.js", "coverage.html"]

        watch:
            build:
                files: ["src/**/*.ts"]
                tasks: ["compile_test", "test", "compile"]
            test:
                files: ["test/**/*.ts"]
                tasks: ["compile_test", "test"]
            config:
                files: ["Gruntfile.*", "*.json"]
                tasks: ["default"]
                options:
                    reload: true

    grunt.loadNpmTasks "grunt-contrib-watch"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-tvm-tsc"
    grunt.loadNpmTasks "grunt-contrib-testem"
    grunt.loadNpmTasks "grunt-mocha-chai-sinon"

    grunt.registerTask "default", ["compile:test", "test:testem", "compile:build"]
    grunt.registerTask "compile:build", ["clean:build", "tvm_tsc:build"]
    grunt.registerTask "compile:test", ["clean:test", "tvm_tsc:test"]
    grunt.registerTask "test", ["test:testem"]
    grunt.registerTask "test:testem", ["testem:test", "mocha-chai-sinon:coverage"]
    grunt.registerTask "test:travis", ["mocha-chai-sinon:travis"]