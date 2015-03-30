// ==UserScript==
// @name         mangapanda chrome removal
// @namespace    http:/www.mangapanda.com/
// @version      0.1
// @description  Remove header/footer/etc.
// @author       davidosomething
// @match        http://*.mangapanda.com/*
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

addGlobalStyle('#wrapper_header { display: none !important; }');
addGlobalStyle('#relatedheader { display: none !important; }');
addGlobalStyle('#relateds { display: none !important; }');
addGlobalStyle('#mangainfo_son { display: none !important; }');
addGlobalStyle('#related { display: none !important; }');
addGlobalStyle('#adfooter { display: none !important; }');
addGlobalStyle('#wrapper_footer { display: none !important; }');
