# ECE/CS 3710
# John Mismash, Zach Phelan, Andrew Porter, Vanessa Bentley

import pygame as p

# Width/Height of the entire game.
WIDTH = HEIGHT = 512

# Dimension of the
DIMENSION = 7

# Each individual square size.
SQUARE_SIZE = HEIGHT // DIMENSION

# FPS for animation of the pieces.
MAX_FPS = 15

# Dictionary of images needed for the Connect 4 game.
IMAGES = {}

p.init()


# Loads all images respective to each square size.
def load_images():
    piece_images = ['RC', 'BC', 'YC']

    for piece in piece_images:
        pass


