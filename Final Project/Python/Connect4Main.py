# ECE/CS 3710
# John Mismash, Zach Phelan, Andrew Porter, Vanessa Bentley

class Game:
    def __init__(self):
        self.Board = [
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
            ['BC', 'BC', 'BC', 'BC', 'BC', 'BC', 'BC'],
        ]

        self.red_turn = False
        self.yellow_turn = False
