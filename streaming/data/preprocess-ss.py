import sys
import math

def read_single_graph(file_name, graph_id):
	'''
	Read a graph with ID in @graph_id from the file @file_name and return the list of its edges.
	'''
	graph = []	# Store graph edges.
	node_id_seen = []	# Whether this node ID has been seen before.
	cnt = 1 	# Artificial timestamps of the edges. 
	with open(file_name) as f:
		for line in f:
			edge = line.strip().split("\t")
			if edge[5] in graph_id:
				if edge[0] in node_id_seen:	# Check if source ID has been seen before.
					edge.append("0")
				else:
					edge.append("1")
					node_id_seen.append(edge[0])
				if edge[2] in node_id_seen:	# Check if destination ID has been seen before.
					edge.append("0")
				else:
					edge.append("1")
					node_id_seen.append(edge[2])
				edge.append(cnt)
				cnt = cnt + 1
				graph.append(edge)
	f.close()
	return graph

def print_instruction():
	print(
		"Usage: python preprocess-ss.py <base_graph_id_start> <base_graph_id_end> <stream_graph_id_start> <stream_graph_id_end> <input_file_path> <base_graph_file_path> <stream_file_path>\n")

if __name__ == "__main__":
	if (len(sys.argv) < 8):
		print_instruction()
		sys.exit(1)

	base_graph_id_start = sys.argv[1]
	base_graph_id_end = sys.argv[2]
	stream_graph_id_start = sys.argv[3]
	stream_graph_id_end = sys.argv[4]
	base_graph_ids = []
	stream_graph_ids = []
	total_ids = []
	for i in range(int(base_graph_id_start), int(base_graph_id_end) + 1):
		base_graph_ids.append(str(i))
		total_ids.append(str(i))
	for i in range(int(stream_graph_id_start), int(stream_graph_id_end) + 1):
		stream_graph_ids.append(str(i))
		total_ids.append(str(i))

	graph = read_single_graph(sys.argv[5], total_ids)

	base_file = open(sys.argv[6], "w")
	stream_file = open(sys.argv[7], "w")

	for edge in graph:
		if edge[5] in base_graph_ids:
			base_file.write(str(edge[0]) + " " + str(edge[2]) + " " + edge[1] + ":" + edge[3] + ":" + edge[4] + ":" + str(edge[8]) + "\n")
		else:
			stream_file.write(str(edge[0]) + " " + str(edge[2]) + " " + edge[1] + ":" + edge[3] + ":" + edge[4] + ":" + edge[6] + ":" + edge[7] + ":" + str(edge[8]) + "\n")


	base_file.close()
	stream_file.close()

