
if(!require(igraph)) install.packages("igraph"); require(igraph)
if(!require(RColorBrewer)) install.packages("RColorBrewer"); require(RColorBrewer)
if(!require(jsonlite)) install.packages("jsonlite"); require(jsonlite)

edges <- c("Luke", "Eshin", 
           "Luke", "Andy",
           "Luke", "Jin",
           "Luke",  "Emma", 
           "Luke", "Daisy")

g_who_supervises_whom <- graph(edges, directed = TRUE)

plot(g_who_supervises_whom, 
     vertex.label.family = "sans",
     vertex.shape = "none")

g_works_in_moore <- graph.full(n = length(unique(edges)), 
                               directed = FALSE, 
                               loops = FALSE)

V(g_works_in_moore)$name <- unique(edges)
plot(g_works_in_moore, vertex.label.family = "sans", vertex.shape = "none")

as_adjacency_matrix(g_who_supervises_whom)

as_edgelist(g_who_supervises_whom)

# load in the edge list
edge_list <- read.csv("./data/socialnetworks/anon_edge_list.csv")

# see what it looks like
head(edge_list)

our_graph <- graph_from_data_frame(edge_list, directed = T)
our_graph

E(our_graph)
V(our_graph)

our_graph <- simplify(our_graph, remove.loops = TRUE)

plot(our_graph)

V(our_graph)$size <- 3
E(our_graph)$arrow.size <- 0.2
E(our_graph)$width <- 0.5
E(our_graph)$color <- "black"

plot(our_graph, vertex.label = NA)

our_graph_mutual <- as.undirected(our_graph, mode="mutual")

# need to reset edge attributes after making the graph undirected
E(our_graph_mutual)$color <- "black" 
E(our_graph_mutual)$width <- 0.5

# plot
plot(our_graph_mutual, vertex.label = NA)

coords <- layout_(our_graph_mutual, with_kk())
head(coords)

plot(our_graph_mutual, vertex.label = NA, layout = coords)

# identify isolates in the undirected (mutual ties only) graph
iso <- names(V(our_graph_mutual)[degree(our_graph_mutual)==0])

# remove isolates from undirected graph (for plotting)
our_graph_mutual_no_iso <- delete.vertices(our_graph_mutual, iso)

coords <- layout_(our_graph_mutual_no_iso, with_kk())

plot(our_graph_mutual_no_iso, vertex.label = NA, layout = coords)

coords <- layout_(our_graph_mutual, randomly())
plot(our_graph_mutual, vertex.label = NA, layout = coords)

coords <- layout_(our_graph_mutual, in_circle())
plot(our_graph_mutual, vertex.label = NA, layout = coords)

fmri_subj <- fromJSON("./data/fmri/fmri_subjects.json")

mycols <- ifelse(V(our_graph_mutual_no_iso)$name %in% fmri_subj, 
                 "tomato", "grey")
V(our_graph_mutual_no_iso)$color <- mycols

coords <- layout_(our_graph_mutual_no_iso, with_kk())
plot(our_graph_mutual_no_iso, vertex.label = NA, layout = coords)

got_edge_list <- read.csv("./data/socialnetworks/stormofswords.csv")
head(got_edge_list)

got_graph <- graph_from_data_frame(got_edge_list, directed = F)
got_graph

# set up function to scale vertex size 
# to some value with a set min and max
scalevals <- function(v, a, b) {v <- v-min(v) 
                                v <- v/max(v) 
                                v <- v * (b-a) 
                                v+a }

# set min and max node sizes
min_size_node = 2 
max_size_node = 5

# scale node size according to node strength (weighted degree centrality)
nodesize_deg = scalevals(degree(got_graph), min_size_node, max_size_node)
nodesize_strength = scalevals(strength(got_graph), min_size_node, max_size_node)

plot(got_graph,
     vertex.size = nodesize_strength,
     vertex.label = NA,
     edge.color="#00000088",
     edge.curved=.2)

# implement fast greedy modularity optimization algorithm 
# to find community structure
communities <- cluster_fast_greedy(got_graph)

# assign community membership as vertex attribute 
V(got_graph)$community <- communities$membership
commnunity_pal <- brewer.pal(max(V(got_graph)$community), "Dark2")

# plot, coloring nodes by community membership
plot(got_graph,
     vertex.size = nodesize_strength,
     vertex.color = commnunity_pal[V(got_graph)$community],
     vertex.label = NA,
     edge.color="#00000088",
     edge.curved=.2)

plot(communities, 
     got_graph,
     vertex.size = nodesize_strength,
     vertex.label = NA,
     edge.color="#00000088",
     edge.curved=.2)

cluster_fast_greedy(got_graph)[[4]]

E(got_graph)[weight>75]

neighbors(got_graph, "Hodor")

got_graph["Daenerys", "Tyrion"]

head(sort(degree(got_graph), decreasing = TRUE))
head(sort(degree(got_graph), decreasing = FALSE))

head(sort(strength(got_graph), decreasing = TRUE))
head(sort(strength(got_graph), decreasing = FALSE))

head(sort(betweenness(got_graph, normalized = TRUE), decreasing = TRUE))

neighbors(got_graph, "Aegon")
neighbors(got_graph, "Ramsay")

head(sort(eigen_centrality(got_graph)$vector, decreasing=TRUE))
head(sort(eigen_centrality(got_graph)$vector, decreasing=FALSE))


coords <- layout_(our_graph_mutual_no_iso, with_kk())
plot(our_graph_mutual_no_iso, vertex.label = NA, layout = coords)
