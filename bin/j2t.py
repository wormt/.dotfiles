#!/usr/bin/env python3
from jinja2 import Environment, FileSystemLoader
import json

vars = json.load(open("vars.json", 'r'))

template = Environment(loader=FileSystemLoader("./")).get_template("template.j2")

for index, i in enumerate(vars):
    content = template.render(i.items())
    outfile = i["outfile"] if i.get("outfile") else str(index)
    with open(outfile, 'w', encoding="utf-8") as f:
        f.write(content)
