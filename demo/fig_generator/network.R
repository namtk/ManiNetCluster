library(tidygraph)
library(ggraph)

net1.1 <- play_geometry(30, 0.25, torus = TRUE)
net1.1 %>% 
  mutate(dist_to_center = node_distance_to(node_is_center())) %>% 
  ggraph(layout = 'kk') + 
  geom_edge_link(colour = '#31a354') + 
  geom_node_point(size = 3.5, colour = '#31a354') + 
  scale_size_continuous(range = c(6, 1)) +
  theme_graph()

net2 <- play_geometry(30, 0.25)
net2 %>% 
  mutate(dist_to_center = node_distance_to(node_is_center())) %>% 
  ggraph(layout = 'kk') + 
  geom_edge_link(colour = '#3182bd') + 
  geom_node_point(size = 3.5, colour = '#3182bd') + 
  scale_size_continuous(range = c(6, 1)) +
  theme_graph()

play_islands(4, 10, 0.8, 3) %>% 
  mutate(community = as.factor(group_infomap())) %>% 
  ggraph(layout = 'kk') + 
  geom_edge_link(show.legend = FALSE) + 
  geom_node_point(aes(colour = community), size = 3.5) + 
  theme_graph()

