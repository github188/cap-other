module.exports = function(grunt) {
    grunt.initConfig({
        pkg : grunt.file.readJSON('package.json'),
        //合并压缩js
        uglify : {
            base : {
                options : {
                    report : "min", //输出压缩率，可选的值有 false(不输出信息)，gzip
                    sourceMap : true
                },
                files : {
                    'base/js/base.js' : ['base/js/src/*.js']
                }
            }
        },
        // 编译 LESS 文件
        less : {
            options : {
                compress : true,
                sourceMap : true
            },
            base : {
                files : {
                    "base/css/base.css" : "base/css/less/base.less"
                },
                options : {
                    sourceMapFilename : 'base/css/base.css.map',
                    //map文件中sources文件的相对url
                    sourceMapBasepath : 'base/css/',
                    //压缩文件中执行map文件的相对地址
                    sourceMapURL : 'base.css.map'
                }
            },
            sidebar : {
                files : {
                    "component/sidebar/css/sidebar.css" : "component/sidebar/css/less/sidebar.less"
                },
                options : {
                    sourceMapFilename : 'component/sidebar/css/sidebar.css.map',
                    sourceMapBasepath : 'component/sidebar/css/',
                    sourceMapURL : 'sidebar.css.map'
                }
            },
            message :{
                files : {
                    "message/css/message.css" : "message/css/less/message.less"
                },
                options : {
                    sourceMapFilename : 'message/css/message.css.map',
                    sourceMapBasepath : 'message/css/',
                    sourceMapURL : 'message.css.map'
                }
            },
            app :{
                files : {
                    "app/css/app.css" : "app/css/less/**.less"
                },
                options : {
                    sourceMapFilename : 'app/css/app.css.map',
                    sourceMapBasepath : 'app/css/',
                    sourceMapURL : 'app.css.map'
                }
            }
        },
        // 复制文件，打包到 dest 文件夹目录下
        copy : {
        },
        // 监控 LESS 文件
        watch : {
            gruntfile : {
                files : ['Gruntfile.js'],
                options : {
                    reload : true
                }
            },
            baseCss : {
                files : ['base/css/**/*.less'],
                tasks : ['less:base']
            },
            baseJs : {
                files : ['base/**/*.js'],
                tasks : ['uglify:base']
            },
            sidebar : {
                files : ['component/sidebar/**/*.less'],
                tasks : ['less:sidebar']
            },
            message : {
                files : ['message/css/less/message.less'],
                tasks : ['less:message']
            },
            app : {
                files : ['app/css/less/**.less'],
                tasks : ['less:app']
            },
            livereload : {
                options : {
                    livereload : true
                },
                files : [
                    '**/*.less',
                    '**/*.jsp'     
                ]
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-jshint');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-less');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.registerTask('default', ['uglify', 'less']);
};