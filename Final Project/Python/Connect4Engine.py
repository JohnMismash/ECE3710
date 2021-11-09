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
    piece_images = ['RP', 'YP', 'BC']

    for piece in piece_images:
        IMAGES[piece] = 0


def main():
    # Creates a console with the specific width and height.
    console = p.display.set_mode((WIDTH, HEIGHT))

    print("hello")

    # Create a clock that will run to check for events.
    game_clock = p.time.Clock()

    console.fill("white")

    # Create a "blank" game state that will allow for all the pieces to be in their
    # respective starting position.
    # game_state = ChessEngine.Game()

    # print(game_state.ChessBoard)

    # Load the images into the global variable so they are accessible. This is only called once
    # in the program.
    load_images()

    # Checks if the console has been closed.
    game_is_running = True

    current_square = ()
    selected_squares = []

    while game_is_running:
        for event in p.event.get():

            if event.type == p.QUIT:
                game_is_running = False

            # If there is a event where a mouse is clicked, we can capture the (x, y)
            # coordinates of where the mouse was clicked.
            elif event.type == p.MOUSEBUTTONDOWN:

                click_location = p.mouse.get_pos()

                # Since our x,y coordinates are now stored in an array, we can access this array
                # and capture the row and column respective to where they clicked.

                # NOTE: Each row and column will start at zero, unlike a representation of an actual chess board.
                click_column = click_location[0] // SQUARE_SIZE
                click_row = click_location[1] // SQUARE_SIZE

                # If the piece has already been selected, we do not want to say this is a valid move,
                # so we can set our selected square variable to be empty to signify a deselection of the piece.
                # Otherwise, we can update the current square that has been selected as normal.
                if current_square != (click_row, click_column):
                    current_square = (click_row, click_column)

                    # Keeps track of the first and second clicks that a player makes.
                    selected_squares.append(current_square)
                    print(selected_squares)
                else:
                    current_square = ()
                    selected_squares = []

                # If the user has made a valid second click to a new square, we want to now
                # perform this valid move within the Chess game.
                if len(selected_squares) == 2:
                    pass

        # DrawGame(console, game_state)
        game_clock.tick(MAX_FPS)
        p.display.flip()


def DrawGame(console, game_state):
    DrawBoard(console)
    DrawPieces(console, game_state.ChessBoard)


def DrawBoard(console):
    # These colors may be changed to be any color scheme of the users choice.
    square_colors = [p.Color("white"), p.Color("gray")]

    # We know that every board setup will always have a "light" square in the top left corner,
    # regardless of the perspective of white/black.

    # We can also set up our square_colors to that the access to a light color is at the 0 index, and the access
    # to a dark color is the 1 index.
    for row in range(DIMENSION):
        for column in range(DIMENSION):
            # When we add the row and column number and mod by 2, we will know whether that
            # position should be a light or dark square if there is a remainder or not, and we can use this
            # remainder of 0 or 1 to access our colors.
            square_color = square_colors[(row + column) % 2]

            # Draw the square given the respective position and color.
            p.draw.rect(console, square_color, (column * SQUARE_SIZE, row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE))


def DrawPieces(console, ChessBoard):
    # Since we know the initial setup of the board, we can access each part of the board, and draw the
    # respective piece image.
    for row in range(DIMENSION):
        for column in range(DIMENSION):
            piece = ChessBoard[row][column]

            if piece != "--":
                piece_image = IMAGES[piece]
                console.blit(piece_image, p.Rect(column * SQUARE_SIZE, row * SQUARE_SIZE, SQUARE_SIZE, SQUARE_SIZE))


if __name__ == "__main__":
    main()
