import sys
import math

def read_single_graph(file_name):
	nodes = []	
	graph = []
	cnt = 1 	# Artificial timestamps of the edges.
	with open(file_name) as f:
		for line in f:
			edge = line.strip().split("\t")
			if edge[0] in nodes:	# Check if source ID has been seen before.
				edge[0] = str(int(edge[0]) - 1)
				edge.append("0")
			else:
				edge.append("1")
				nodes.append(edge[0])
				edge[0] = str(int(edge[0]) - 1)
			if edge[1] in nodes:	# Check if destination ID has been seen before.
				edge[1] = str(int(edge[1]) - 1)
				edge.append("0")
			else:
				edge.append("1")
				nodes.append(edge[1])
				edge[1] = str(int(edge[1]) - 1)
			attributes = edge[2].strip().split(":")
			source_node_type = attributes[0]
			destination_node_type = attributes[1]
			edge_type = attributes[2]
			edge[2] = source_node_type
			edge.append(destination_node_type)
			edge.append(edge_type)
			edge.append(cnt)
			cnt = cnt + 1
			graph.append(edge)
	f.close()
	return graph

def print_instruction():
	print(
		"Usage: python fix.py <input_file_path> <base_graph_file_path> <stream_file_path>\n"
		"The first 10% of the edges in the graph will be considered as the basis of the streaming graph, stored in <base_graph_file_path>.\n"
		"The rest of the edges will be streamed in, stored in <stream_file_path>.\n")


if __name__ == "__main__":
	if (len(sys.argv) < 4):
		sys.exit(1)

	graph = read_single_graph(sys.argv[1])
	base_graph_size = math.ceil(len(graph) * 0.1)	# The size of base graph.
	stream_graph_size = len(graph) - base_graph_size

	base_file = open(sys.argv[2], "w")
	stream_file = open(sys.argv[3], "w")

	cnt = 0
	for edge in graph:
		if cnt < base_graph_size:
			cnt = cnt + 1
			base_file.write(str(edge[0]) + " " + str(edge[1]) + " " + edge[2] + ":" + edge[5] + ":" + edge[6] + ":" + str(edge[7]) + "\n")
		else:
			stream_file.write(str(edge[0]) + " " + str(edge[1]) + " " + edge[2] + ":" + edge[5] + ":" + edge[6] + ":" + edge[3] + ":" + edge[4] + ":" + str(edge[7]) + "\n")

	print "Done with: " + sys.argv[1]
	
	base_file.close()
	stream_file.close()