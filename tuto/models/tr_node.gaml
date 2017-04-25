/**
* Name: trnode
* Author: Eoxys-Win10
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model graph_model

global
{
    int number_of_agents <- 50;
    init
    {
        create graph_agent number: number_of_agents;
    }

    reflex update {
        ask graph_agent(one_of(graph_agent)) {
            status <- 2;
            do update_neighbors;
        }
    }
}

species graph_agent parent: graph_node edge_species: edge_agent
{
    int status <- 0;
    list<int> list_connected_index;

    init {
        int i<-0;
        loop i over: graph_agent {
            if (flip(0.1)) {
                add i to: list_connected_index;
            }
            i <- i+1;
        }
    }

    bool related_to(graph_agent other){
        if (list_connected_index contains (graph_agent index_of other)) {
            return true;
        }
        return false;
    }

    action update_neighbors {

        list<graph_agent> list_neighbors <- list<graph_agent>(my_graph neighbors_of (self));

        loop neighb over:list_neighbors {
            neighb.status <- 1;
        }
    }

    aspect base
    {
        if (status = 0) {
            draw circle(2) color: # green;
        }
        else if (status = 1) {
            draw circle(2) color: # yellow;
        }
        else if (status = 2) {
            draw circle(2) color: # red;
        }
        //draw text:string(my_graph degree_of self) color:# black size:4 at:point(self.location.x-1,self.location.y-2);
        status <- 0;
    }
}

species edge_agent parent: base_edge
{
    aspect base
    {
        draw shape color: # blue;
    }
}

experiment MyExperiment type: gui
{
    output
    {
        display MyDisplay type: java2D
        {
            species graph_agent aspect: base;
            species edge_agent aspect: base;
        }
    }
}


