module.exports = (grunt) ->
    grunt.initConfig(
        pkg: grunt.file.readJSON('package.json'),
        coffee:
            glob_to_multiple:
                expand: true
                flatten: false
                cwd: 'src'
                src: ['**/*.coffee']
                dest: 'lib'
                ext: '.js'
            glob_to_multiple2:
                expand: true
                flatten: false
                cwd: 'test'
                src: ['**/*.coffee']
                dest: 'test'
                ext: '.js'
            
        copy:
            copy_js:
                files:[
                    {cwd:'src',src:['**/*.js'],dest:'lib/',expand:true,flatten:false,filter:'isFile'},                    
                ]
        
                
    )
    
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-copy')    
    grunt.registerTask('default',['coffee','copy:copy_js'])
    

