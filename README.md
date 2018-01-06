Hitori Puzzle Solver
============

This Hitori Puzzle Solver is one of the projects that I developed for the Knowledge Representation and Automatic Reasoning course in the junior year of my undergrad in computer science at UDC (Spain). It transforms a simplified version of the Hitori puzzle into a set of CNF boolean clauses based on the rules of the game, calls a propositional satisfiability (SAT) solver and creates the solution.


Tail recursion


## Hitori puzzle

- **Recursive list implementation** and operations over the list (length, concat, append, join, combine...)
- **Tail recursion sorting** analysis of given functions 
- **Object oriented dynamic array** with the following methods:
	- addLast(element)
	- add(element,position)
	- overwrite(element,position)
	- lenght()
	- get(position)
	- index(position)
	- toString()
	- toStringBuffer()
- **World of blocks solver**. Given a starting configuration and a goal, it efficiently produces the set of moves (up, down, left, right, grab, drop) that transform the starting configuration into the finishing configuration. Also a given (by the professor) .tcl script provides a graphical interface that animates the sequence. 
<p align="center">
<img src="https://github.com/DaniRuizPerez/Ocaml/blob/master/block.PNG" width="500">
</p>

## Contact

Contact [Daniel Ruiz Perez](mailto:druiz072@fiu.edu) for requests, bug reports and good jokes.


## License

The software in this repository is available under the GNU General Public License, version 3. See the [LICENSE](https://github.com/DaniRuizPerez/AutomaticReasoning/blob/master/LICENSE) file for more information.
