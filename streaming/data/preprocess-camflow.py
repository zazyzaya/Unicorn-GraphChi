import sys
import math

def read_single_graph(file_name, graph_id):
	'''
	Read a graph with ID in @graph_id from the file @file_name and return the list of its edges with newly assigned node ID.
	'''
	map_id = {}	# maps original ID to new ID
	graph = []	# Store graph edges.
	cnt = 1 	# Artificial timestamps of the edges.
	new_id = 0	# Reassign sequential IDs from 0.
	with open(file_name) as f:
		for line in f:
			edge = line.strip().split("\t")
			if edge[5] in graph_id:
				if edge[0] in map_id:	# Check if source ID has been seen before.
					edge[0] = map_id[edge[0]]
					edge.append("0")
				else:
					edge.append("1")
					map_id[edge[0]] = str(new_id)
					edge[0] = str(new_id)
					new_id = new_id + 1
				if edge[2] in map_id:	# Check if destination ID has been seen before.
					edge[2] = map_id[edge[2]]
					edge.append("0")
				else:
					edge.append("1")
					map_id[edge[2]] = str(new_id)
					edge[2] = new_id
					new_id = new_id + 1
				edge.append(cnt)
				cnt = cnt + 1
				graph.append(edge)
	f.close()
	return graph

def print_instruction():
	print(
		"Usage: python preprocess-camflow.py <graph_id> <input_file_path> <base_graph_file_path> <stream_file_path>\n"
		"The first 10% of the edges in the graph will be considered as the basis of the streaming graph, stored in <base_graph_file_path>.\n"
		"The rest of the edges will be streamed in, stored in <stream_file_path>.\n")

if __name__ == "__main__":
	if (len(sys.argv) < 5):
		print_instruction()
		sys.exit(1)

	graph = read_single_graph(sys.argv[2], sys.argv[1])
	base_graph_size = math.ceil(len(graph) * 0.1)	# The size of base graph.
	stream_graph_size = len(graph) - base_graph_size

	base_file = open(sys.argv[3], "w")
	stream_file = open(sys.argv[4], "w")

	cnt = 0
	for edge in graph:
		if cnt < base_graph_size:
			cnt = cnt + 1
			base_file.write(str(edge[0]) + " " + str(edge[2]) + " " + edge[1] + ":" + edge[3] + ":" + edge[4] + ":" + str(edge[8]) + "\n")
		else:
			stream_file.write(str(edge[0]) + " " + str(edge[2]) + " " + edge[1] + ":" + edge[3] + ":" + edge[4] + ":" + edge[6] + ":" + edge[7] + ":" + str(edge[8]) + "\n")


	base_file.close()
	stream_file.close()