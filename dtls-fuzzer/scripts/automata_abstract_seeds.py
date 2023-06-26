#!/usr/bin/env python3

import sys
import pydot
#import pprint
import copy

def t_cover(states, edges, alphabet, init_state):
    # traces will be the result
    traces = []
    # waiting[i] = (a trace to reach curr_state, curr_state)
    waiting = [([], init_state)]
    # passed contains all the edges already visited
    passed = set()
    # continue until no more state to explore
    while waiting:
        # BFS: select and remove the first element
        (curr_trace, curr_state) = waiting.pop(0)
        # look for successor
        has_successor = False
        for a in alphabet:
            key = (curr_state, a)
            # the successor exists and the edge hasn't been visited yet
            if edges[key] and not key in passed:
                has_successor = True
                # compute next trace by appending letter a
                next_trace = []
                if curr_trace:
                    next_trace = copy.deepcopy(curr_trace)
                    next_trace.append(a)
                else:
                    next_trace = [a]
                # get next state
                next_state = edges[key][0]
                waiting.append((next_trace, next_state))
                passed.add(key)
        if not has_successor:
            traces.append(curr_trace)
    return traces

def build_seeds(traces, outdir):
    traces.sort(key=len, reverse=True)
    saved_prefixes = []
    s_id = 0
    for trace in traces:
        #print("-----")
        #print(trace)
        for l in range(0, len(trace)):
            # comp_prefix = prefix + 1 mutated message
            comp_prefix = trace[0:l+1]
            #print(comp_prefix)
            if not comp_prefix in saved_prefixes:
                saved_prefixes.append(comp_prefix)
                # write length file
                f = open("{0}/seed-{1:04d}.length".format(outdir, s_id), 'w')
                f.write(str(l)+"\n")
                f.close()
                # write abstract file
                f = open("{0}/seed-{1:04d}.abstra".format(outdir, s_id), 'w')
                for a in trace:
                    f.write(a+"\n")
                f.close()
                s_id = s_id + 1


if len(sys.argv)<=1:
    print("ERROR: missing argument (dot filename)")
elif len(sys.argv)<=2:
    print("ERROR: missing argument (output folder)")
else:
    fname = sys.argv[1]
    outdir = sys.argv[2]
    g = pydot.graph_from_dot_file(fname)[0]

    states = set()
    init_state = None
    alphabet = set()
    edges = {}

    replacements = {'"': '', "'": '', ' ': ''}
    for node in g.get_nodes():
        node_name = node.get_name()
        if node_name == '__start0' \
            or node_name == "\"\\n\\n\"":
            continue
        states.add(node_name)
        #print(node_name)
    for edge in g.get_edges():
        node_src = edge.get_source()
        node_dst = edge.get_destination()
        if node_src == '__start0':
            init_state = node_dst
            #print(initial_state)
            continue
        label = edge.get_label()
        if not label:
            continue
        label = label.replace('"','').replace(' ','')
        #print(node_src+" --"+label+"-> "+node_dst)
        label = label.split('/')
        #print(label)
        alphabet.add(label[0])
        edges[node_src, label[0]] = [node_dst, label[1]]
    #print(alphabet)
    #print(transitions)
    traces = t_cover(states, edges, alphabet, init_state)
    #tot = 0
    #for trace in traces:
    #    print(trace)
    #    tot = tot + len(trace)
    #print(len(traces))
    #print(tot)
    build_seeds(traces, outdir)
