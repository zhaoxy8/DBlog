<#include "include/macros.ftl">
<@compress single_line=true>

<div class="container custome-container">
    <nav class="breadcrumb">
        <a class="crumbs" title="return home" href="${config.siteUrl}" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-home"></i>Home</a>
    </nav>
    <div class="row about-body">
        <@blogHeader title="kubernetes"></@blogHeader>
        <div class="col-sm-12 blog-main">
            <div class="blog-body expansion">
                <h5 class="custom-title"><i class="fa fa-user-secret fa-fw"></i><strong>Introduction</strong><small></small></h5>
                <div class="info">
                    <p>
                        Thanks for using kubernetes
                    </p>
                </div>
                <h5 class="custom-title"><i class="fa fa-coffee fa-fw"></i><strong>Docker</strong><small></small></h5>
                <div class="info">
                    Jenkins pipline is very handy for creating docker images <br>
                </div>
                <h5 class="custom-title"><i class="fa fa-copyright fa-fw"></i><strong>Welcome to kubernetes</strong><small></small></h5>

                <@praise></@praise>
            </div>
        </div>
        <#--<div class="col-sm-12 blog-main">
            <div class="blog-body expansion">
                <div id="comment-box" data-id="-3"></div>
            </div>
        </div>-->
    </div>
</div>

<@footer>
    <script src="https://v1.hitokoto.cn/?encode=js&c=d&select=%23hitokoto" defer></script>
</@footer>
