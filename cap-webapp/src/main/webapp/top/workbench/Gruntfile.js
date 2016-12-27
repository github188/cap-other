module.exports = function(grunt) {
    grunt.initConfig({
        pkg : grunt.file.readJSON('package.json'),
        //�ϲ�ѹ��js
        uglify : {
            base : {
                options : {
                    report : "min", //���ѹ���ʣ���ѡ��ֵ�� false(�������Ϣ)��gzip
                    sourceMap : true
                },
                files : {
                    'base/js/base.js' : ['base/js/src/*.js']
                }
            }
        },
        // ���� LESS �ļ�
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
                    //map�ļ���sources�ļ������url
                    sourceMapBasepath : 'base/css/',
                    //ѹ���ļ���ִ��map�ļ�����Ե�ַ
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
        // �����ļ�������� dest �ļ���Ŀ¼��
        copy : {
        },
        // ��� LESS �ļ�
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