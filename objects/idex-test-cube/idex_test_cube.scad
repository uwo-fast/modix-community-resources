// IDEX test cube, modelled by the FAST research group for testing IDEX printers.
// A 3 x 3 x 3 grid of cubic cells with a set of channels cut through it.
// SPDX-License-Identifier: MIT
//
// Origin: centred on X and Y, sitting on Z = 0.

/* [Size] */
// Edge length of one grid cell
cell = 10;

/* [Hidden] */
// Solid cells, indexed [layer z][row y][column x], from -X/-Y/bottom upward.
// 1 = solid, 0 = channel.
cells = [
    [ // bottom layer
        [1, 1, 1],
        [0, 0, 0],
        [1, 0, 1],
    ],
    [ // middle layer
        [1, 0, 1],
        [0, 0, 0],
        [1, 0, 1],
    ],
    [ // top layer
        [1, 0, 1],
        [1, 0, 1],
        [1, 0, 1],
    ],
];
n = len(cells[0][0]); // cells per side

module idex_test_cube() {
    translate([-n * cell / 2, -n * cell / 2, 0])
        union()
            for (z = [0 : len(cells) - 1], y = [0 : n - 1], x = [0 : n - 1])
                if (cells[z][y][x] == 1)
                    translate([x, y, z] * cell) cube(cell);
}

idex_test_cube();
