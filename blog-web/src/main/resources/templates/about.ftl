<#include "include/macros.ftl">
<@compress single_line=true>
<@header title="about | ${config.siteName}" keywords="${config.siteName},Docker" description="${config.siteName}" canonical="/about"></@header>

<div class="container custome-container">
    <nav class="breadcrumb">
        <a class="crumbs" title="HOME" href="${config.siteUrl}" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-home"></i>HOME</a>
        <i class="fa fa-angle-right"></i>about
    </nav>
    <div class="row about-body">
        <@blogHeader title=""></@blogHeader>
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
                <h5 class="custom-title"><i class="fa fa-copyright fa-fw"></i><strong>Docker</strong><small></small></h5>
                <div class="info">
                    
                </div>
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
