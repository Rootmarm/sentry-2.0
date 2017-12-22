First off, this is obviously not my work, but have mirrored it here for convenience and reference.



**What is Sentry?**
===============

This would be the precursor to the Sentry MBA series of brute force/credential stuffing tools popular today. 

The following blog posts should provide a quick introduction:

https://blog.shapesecurity.com/tag/sentry-mba/

https://spycloud.com/tools-criminals-using-crack-website/



**How is this tool used?**
====================
The heart of the tool consists of an http requests generator coupled by a proxy switcher and wordlist cycling, multithreaded to create many instances with which the target may be attacked. This also enables the tool to make api calls with spoofed credentials. 

This version does not have the OCR anti-captcha abilities seen later.


**How do I build this?**
===================

[RAD Studio.](https://www.embarcadero.com/products/rad-studio) Note that it is built for Win32 only.

Also, the package as found may be missing some graphical components.


Changelog is in readme.txt