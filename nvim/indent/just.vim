" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif

runtime! indent/make.vim          " will set b:did_indent
