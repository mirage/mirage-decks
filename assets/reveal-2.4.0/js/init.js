// Full list of configuration options available here:
// https://github.com/hakimel/reveal.js#configuration
Reveal.initialize({
    controls: true,
    progress: true,
    history: true,
    center: false,
    margin:0.07,

    theme: Reveal.getQueryHash().theme, // available themes are in /css/theme
    transition: Reveal.getQueryHash().transition || "fade", // default/cube/page/concave/zoom/linear/fade/none

    // Optional libraries used to extend on reveal.js
    dependencies: [
        { src: "/reveal-2.4.0/lib/js/classList.js", condition: function() { return !document.body.classList; } },
        { src: "/reveal-2.4.0/plugin/markdown/marked.js", condition: function() { return !!document.querySelector( "[data-markdown]" ); } },
        { src: "/reveal-2.4.0/plugin/markdown/markdown.js", condition: function() { return !!document.querySelector( "[data-markdown]" ); } },
        { src: "/reveal-2.4.0/plugin/highlight/highlight.js", async: true, callback: function() { hljs.initHighlightingOnLoad(); } },
        { src: "/reveal-2.4.0/plugin/zoom-js/zoom.js", async: true, condition: function() { return !!document.body.classList; } },
        { src: "/reveal-2.4.0/plugin/notes/notes.js", async: true, condition: function() { return !!document.body.classList; } }
        // { src: "/reveal-2.4.0/plugin/search/search.js", async: true, condition: function() { return !!document.body.classList; } }
        // { src: "/reveal-2.4.0/plugin/remotes/remotes.js", async: true, condition: function() { return !!document.body.classList; } }
    ]
});

var slideNumber = document.querySelector("#slide-number");
var updateSlideNumber = function(event) {
    slideNumber.textContent =
        (event.indexh > 0)
        ? event.indexh + "\u2014" + (event.indexv +1)
        : "";
}

Reveal.addEventListener("ready", updateSlideNumber);
Reveal.addEventListener("slidechanged", updateSlideNumber);
