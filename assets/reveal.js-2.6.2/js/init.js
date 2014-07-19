Reveal.initialize({
    center: false,
    history: true,
    slideNumber: true,
    theme: Reveal.getQueryHash().theme,
    transition: Reveal.getQueryHash().transition || "fade",

    dependencies: [
        // cross-browser classlist shim
        { src: "/reveal.js-2.6.2/lib/js/classList.js",
          condition: function()
          {
              return !document.body.classList;
          }
        },

        // markdown slide support
        { src: "/reveal.js-2.6.2/plugin/markdown/marked.js",
          condition: function()
          {
              return !!document.querySelector( "[data-markdown]" );
          }
        },
        { src: "/reveal.js-2.6.2/plugin/markdown/markdown.js",
          condition: function()
          {
              return !!document.querySelector( "[data-markdown]" );
          }
        },

        // syntax highlight <code> elements
        { src: "/reveal.js-2.6.2/plugin/highlight/highlight.js", async: true,
          callback: function() { hljs.initHighlightingOnLoad(); } },
    ]

});
