ggtreeghost <- function(tr,
                        mapping        = NULL,
                        layout         = "rectangular",
                        open.angle     = 0,
                        mrsd           = NULL,
                        as.Date        = FALSE,
                        yscale         = "none",
                        yscale_mapping = NULL,
                        ladderize      = TRUE,
                        right          = FALSE,
                        branch.length  = "branch.length",
                        ndigits        = NULL, ...) {

    layout %<>% match.arg(c("rectangular", "slanted", "fan", "circular", "radial", "unrooted"))

    if (is(tr, "r8s") && branch.length == "branch.length") {
        branch.length = "TREE"
    }

    if(yscale != "none") {
        ## for 2d tree
        layout <- "slanted"
    }

    if (is.null(mapping)) {
        mapping <- aes_(~x, ~y)
    } else {
        mapping <- modifyList(aes_(~x, ~y), mapping)
    }
    p %g<% ggplot(tr, mapping=mapping,
                  layout        = layout,
                  mrsd          = mrsd,
                  as.Date       = as.Date,
                  yscale        = yscale,
                  yscale_mapping= yscale_mapping,
                  ladderize     = ladderize,
                  right         = right,
                  branch.length = branch.length,
                  ndigits       = ndigits) ##, ...) ## as.list and extract parameter maybe use in ggplot(fortify).

    if (is(tr, "multiPhylo")) {
        multiPhylo <- TRUE
    } else {
        multiPhylo <- FALSE
    }

    p <- p + geom_tree(layout=layout, multiPhylo=multiPhylo) ##, ...)


    p <- p + theme_tree()

    if (layout == "circular" || layout == "radial") {
        p <- layout_circular(p)
        ## refer to: https://github.com/GuangchuangYu/ggtree/issues/6
        ## and also have some space for tree scale (legend)
        p <- p + ylim(0, NA)
    } else if (layout == "fan") {
        p <- layout_fan(p, open.angle)
    }

    return(p)
}
