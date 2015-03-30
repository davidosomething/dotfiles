// ==UserScript==
// @name         bato.to chrome removal
// @namespace    http://bato.to/
// @version      0.1
// @description  Remove header/footer/etc.
// @author       davidosomething
// @match        http://bato.to/*
// @grant        none
// ==/UserScript==

function addGlobalStyle(css) {
    var head, style;
    head = document.getElementsByTagName('head')[0];
    if (!head) { return; }
    style = document.createElement('style');
    style.type = 'text/css';
    style.innerHTML = css;
    head.appendChild(style);
}

addGlobalStyle('#user_bar { display: none !important; }');
addGlobalStyle('#branding { display: none !important; }');
addGlobalStyle('#footer_utilities { display: none !important; }');
addGlobalStyle('#zoom_notice { display: none !important; }');
addGlobalStyle('#comic_wrap div { top: 0 !important; }');
