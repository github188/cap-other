    var LoginAction = {};
    var wl_cst = cst.use('workBench_login_cst', 30),
        cstData = wl_cst.get('loginFormData'),
        $remember = $('#rememberMe'),
        $loginBtn = $('#loginBtn'),
        $userName = $('#userName'),
        $passWord = $('#passWord'),
        $loginForm = $('#loginForm');
    //如果存在本地数据，则加载，并绑定到表单当中
    if(cstData){
        $userName.val(cstData.userName);//.parent().prev().hide();
        $passWord.val(cstData.passWord);//.parent().prev().hide();
        $remember.prop('checked', true);
    }else{
        $passWord.val('');
    }
    
    if($.trim($userName.val())){
        $userName.parent().prev().hide();
    }
    if($.trim($passWord.val())){
        $passWord.parent().prev().hide();
    }
    
    /**
     * 提示处理
     * @param isShow {Boolean} 是否显示
     * @param content {String} 提示内容
     */
    function loginTipHandle(show, content){
        var $tip = $('#loginTip'),
            v = show ? 'visible' : 'hidden';
        $tip.text(content || '请输入有效的用户名或密码！').css('visibility', v);
    }
    
    /**
     * 登录按钮处理
     * @param disable {Boolean} 是否可用
     */
    function loginBtnHandle(disable){
        if(disable){
            $loginBtn.addClass('login-btn-disable').text('登录中...').data('disable', true);
        }else{
            $loginBtn.removeClass('login-btn-disable').text('登录').data('disable', false);
        }
    }

    /**
     * 表单前端验证
     * @returns {boolean}
     */
    function formValidateHandle(){
        var pass = true,
            tip = '',
            state = 0,
            $userNameWrap = $userName.parents('.login-input-wrap').eq(0),
            $passWordWrap = $passWord.parents('.login-input-wrap').eq(0);

        if($.trim($userName.val()) === ''){
            tip = '请输入用户名';
            pass = false;
            $userNameWrap.addClass('login-input-error');
            state = 1;
        }
        if($passWord.val() === ''){
            tip = '请输入密码';
            pass = false;
            $passWordWrap.addClass('login-input-error');
            state = 2;
        }
        if($.trim($userName.val()) === '' && $passWord.val() === ''){
            tip = '请输入用户名和密码';
            pass = false;
            $userNameWrap.addClass('login-input-error');
            $passWordWrap.addClass('login-input-error');
            state = 3;
        }
        switch (state){
            case 2:
                $passWord.focus();
                break;
            default :
                $userName.focus();
        }
        loginTipHandle(!pass, tip);
        return pass;
    }

    /**
     * 记住我处理
     */
    function rememberMeHandle(remember){
        var loginFormData = {};
        if(remember){
            loginFormData = {
                userName: $.trim($userName.val()),
                passWord: $passWord.val()
            };
            wl_cst.set('loginFormData', loginFormData);
        }else{
            wl_cst.remove('loginFormData');
        }
    }

    //登录按钮事件绑定
    $loginBtn.on('click', submitForm);
    
    function submitForm(){
        //如果按钮被禁，则不能执行表单提交
        if($loginBtn.data('disable') || !formValidateHandle()){
            return;
        }
        //禁用按钮
        loginBtnHandle(true);
        
        //记住我
        if($remember[0].checked){
            rememberMeHandle(true);
        }else{
            rememberMeHandle(false);
        }
        
        $loginForm.submit();
    }

    //提示文字与获焦样式控制
    $('#loginForm input').on('focus', function(){
        var $t = $(this),
            $parent = $t.parents('.login-input-wrap').eq(0),
            $emptyText = $parent.children('span');
        $parent.addClass('login-input-focus');
        $emptyText.hide();
    }).on('blur', function(){
        var $t = $(this),
            $parent = $t.parents('.login-input-wrap').eq(0),
            $emptyText = $parent.children('span');
        $parent.removeClass('login-input-focus');
        if($.trim($t.val()) === ''){
            $emptyText.show();
        }else{
            $emptyText.hide();
            $parent.removeClass('login-input-error');
        }
    });
    //IE6/7/8 hack处理
    $('.login-input-wrap span').on('mousedown', function(){
        var $t = $(this);
        setTimeout(function(){
            $t.next().children('input').focus();
            $t = undefined;
        },0);
    });

    //添加收藏
    $('#addFav').on('click', function(){
        var url = window.location.href,
            title = document.title;
        var ua = navigator.userAgent.toLowerCase();
        if (ua.indexOf("360se") > -1) {
            alert("由于360浏览器功能限制，请按 Ctrl+D 手动收藏！");
        }else if (ua.indexOf("msie 8") > -1) {
            window.external.AddToFavoritesBar(url, title); //IE8
        }else if (document.all) {
            try{
                window.external.addFavorite(url, title);
            }catch(e){
                alert('您的浏览器不支持,请按 Ctrl+D 手动收藏!');
            }
        } else if (window.sidebar && window.sidebar.addPanel) {
            window.sidebar.addPanel(title, url, "");
        } else {
            alert('您的浏览器不支持,请按 Ctrl+D 手动收藏!');
        }
        return false;
    });

    //监听键盘事件
    $(document).on('keypress', function(e){
        if(e.keyCode === 13){
            $loginBtn.click();
        }
    });

    //解决IE刷新没办法获焦问题
    setTimeout(function(){
        $userName.focus();
    },0);

    //清空工作台激活缓存
    cst.use('portletTask').clear();


    //暴露消息提示方法
    LoginAction.loginTipHandle = loginTipHandle;
    LoginAction.forgetFormData = function(){
        wl_cst.remove('loginFormData'); 
    }
