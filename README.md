Six Degrees of Separation
==============

It's Easy!
--------------

Find out how closely related two actors / actresses are by scraping IMDB.  

It uses a modified [breadth-first search](http://en.wikipedia.org/wiki/Breadth-first_search) based on a graph of actor / movie nodes that I create on the fly.  Well, that's the coolest way I could think of to describe it, but read the code.  It's only 100 lines!

If you want to quickly try it out, install Nokogiri (for HTML parsing):

    gem install nokogiri

Then, run the quick example I created - how many movies link Ryan Gosling and Steve Carell:  

    ruby degrees_of_separation.rb

You should get **1**.  I provided this example because scraping IMDB will take awhile -- for less easily connected actors it will take on the order of a few minutes to run.

Have a Better Solution?
---------------

Let me know.  Pull requests welcome, and if you have a better algorithm feel free to open an issue.  Enjoy!
