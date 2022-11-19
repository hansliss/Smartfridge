// MIT License
//
// Copyright 2019 Electric Imp
//
// SPDX-License-Identifier: MIT
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

// Temperature Humidity sensor Library
#require "HTS221.device.lib.nut:2.0.1"

/**
 * Library-specific constants
 *
 * @enum
 */
enum SSD1306_CONSTANTS {
    // Display constants
    SETLOWCOLUMN = 0x00
    EXTERNALVCC = 0x01,
    SWITCHCAPVCC = 0x02,
    SETHIGHCOLUMN = 0x10,
    MEMORYMODE = 0x20,
    COLUMNADDR = 0x21,
    PAGEADDR = 0x22,
    RIGHT_HORIZONTAL_SCROLL = 0x26,
    LEFT_HORIZONTAL_SCROLL = 0x27,
    VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL = 0x29,
    VERTICAL_AND_LEFT_HORIZONTAL_SCROLL = 0x2A,
    DEACTIVATE_SCROLL = 0x2E,
    ACTIVATE_SCROLL = 0x2F,
    WRITETOBUFFER = 0x40,
    SETSTARTLINE = 0x40,
    SETCONTRAST = 0x81,
    CHARGEPUMP = 0x8D,
    SEGREMAP = 0xA1,
    SET_VERTICAL_SCROLL_AREA = 0xA3,
    DISPLAYALLON_RESUME = 0xA4,
    DISPLAYALLON = 0xA5,
    NORMALDISPLAY = 0xA6,
    INVERTDISPLAY = 0xA7,
    SETMULTIPLEX = 0xA8,
    DISPLAYOFF = 0xAE,
    DISPLAYON = 0xAF,
    COMSCANINC = 0xC0,
    COMSCANDEC = 0xC8,
    SETDISPLAYOFFSET = 0xD3,
    SETDISPLAYCLOCKDIV = 0xD5,
    SETPRECHARGE = 0xD9,
    SETCOMPINS = 0xDA,
    SETVCOMDETECT = 0xDB,
    // Scrolling constants
    ACTIVATE_SCROLL = 0x2F,
    DEACTIVATE_SCROLL = 0x2E,
    SET_VERTICAL_SCROLL_AREA = 0xA3,
    RIGHT_HORIZONTAL_SCROLL = 0x26,
    LEFT_HORIZONTAL_SCROLL = 0x27,
    VERTICAL_AND_RIGHT_HORIZONTAL_SCROLL = 0x29,
    VERTICAL_AND_LEFT_HORIZONTAL_SCROLL = 0x2A
}

/**
 * Hardware driver for Adafruit 128 x 32 and 128 x 64 OLED displays
 * based on the Solomon SSD§1306 controller.
 * For example: http://www.adafruit.com/products/931
 *
 * Bus          I2C
 * Availibility Device
 * @author      Tony Smith (@smittytone)
 * @license     MIT
 *
 * @class
 */
class SSD1306OLED {

    /**
     * @property {string} VERSION - The library version
     */
    static VERSION = "1.0.0";

    /**
     * @property {array} CHARSET - The proportionally spaced alphanumeric character set
     */
    static CHARSET_COUNT = 96;
    static CHARSET = [
        "\x00\x00",             // space - Ascii 32
        "\xfa",                 // !
        "\xe0\xc0\x00\xe0\xc0", // "
        "\x24\x7e\x24\x7e\x24", // #
        "\x24\xd4\x56\x48",     // $
        "\xc6\xc8\x10\x26\xc6", // %
        "\x6c\x92\x6a\x04\x0a", // &
        "\xc0",                 // '
        "\x7c\x82",             // (
        "\x82\x7c",             // )
        "\x10\x7c\x38\x7c\x10", // *
        "\x10\x10\x7c\x10\x10", // +
        "\x06\x07",             // ,
        "\x10\x10\x10\x10\x10", // -
        "\x06\x06",             // .
        "\x04\x08\x10\x20\x40", // /
        "\x7c\x8a\x92\xa2\x7c", // 0 - Ascii 48
        "\x42\xfe\x02",         // 1
        "\x46\x8a\x92\x92\x62", // 2
        "\x44\x92\x92\x92\x6c", // 3
        "\x18\x28\x48\xfe\x08", // 4
        "\xf4\x92\x92\x92\x8c", // 5
        "\x3c\x52\x92\x92\x8c", // 6
        "\x80\x8e\x90\xa0\xc0", // 7
        "\x6c\x92\x92\x92\x6c", // 8
        "\x60\x92\x92\x94\x78", // 9
        "\x36\x36",             // : - Ascii 58
        "\x36\x37",             // ;
        "\x10\x28\x44\x82",     // <
        "\x24\x24\x24\x24\x24", // =
        "\x82\x44\x28\x10",     // >
        "\x60\x80\x9a\x90\x60", // ?
        "\x7c\x82\xba\xaa\x78", // @
        "\x7e\x90\x90\x90\x7e", // A - Ascii 65
        "\xfe\x92\x92\x92\x6c", // B
        "\x7c\x82\x82\x82\x44", // C
        "\xfe\x82\x82\x82\x7c", // D
        "\xfe\x92\x92\x92\x82", // E
        "\xfe\x90\x90\x90\x80", // F
        "\x7c\x82\x92\x92\x5c", // G
        "\xfe\x10\x10\x10\xfe", // H
        "\x82\xfe\x82",         // I
        "\x0c\x02\x02\x02\xfc", // J
        "\xfe\x10\x28\x44\x82", // K
        "\xfe\x02\x02\x02\x02", // L
        "\xfe\x40\x20\x40\xfe", // M
        "\xfe\x40\x20\x10\xfe", // N
        "\x7c\x82\x82\x82\x7c", // O
        "\xfe\x90\x90\x90\x60", // P
        "\x7c\x82\x92\x8c\x7a", // Q
        "\xfe\x90\x90\x98\x66", // R
        "\x64\x92\x92\x92\x4c", // S
        "\x80\x80\xfe\x80\x80", // T
        "\xfc\x02\x02\x02\xfc", // U
        "\xf8\x04\x02\x04\xf8", // V
        "\xfc\x02\x3c\x02\xfc", // W
        "\xc6\x28\x10\x28\xc6", // X
        "\xe0\x10\x0e\x10\xe0", // Y
        "\x86\x8a\x92\xa2\xc2", // Z - Ascii 90
        "\xfe\x82\x82",         // [
        "\x40\x20\x10\x08\x04", // \
        "\x82\x82\xfe",         // ]
        "\x20\x40\x80\x40\x20", // ^
        "\x02\x02\x02\x02\x02", // _
        "\xc0\xe0",             // '
        "\x04\x2a\x2a\x2a\x1e", // a - Ascii 97
        "\xfe\x22\x22\x22\x1c", // b
        "\x1c\x22\x22\x22",     // c
        "\x1c\x22\x22\x22\xfc", // d
        "\x1c\x2a\x2a\x2a\x10", // e
        "\x10\x7e\x90\x90\x80", // f
        "\x18\x25\x25\x25\x3e", // g
        "\xfe\x20\x20\x20\x1e", // h
        "\xbe\x02",             // i
        "\x02\x01\x01\x21\xbe", // j
        "\xfe\x08\x14\x22",     // k
        "\xfe\x02",             // l
        "\x3e\x20\x18\x20\x1e", // m
        "\x3e\x20\x20\x20\x1e", // n
        "\x1c\x22\x22\x22\x1c", // o
        "\x3f\x22\x22\x22\x1c", // p
        "\x1c\x22\x22\x22\x3f", // q
        "\x22\x1e\x22\x20\x10", // r
        "\x12\x2a\x2a\x2a\x04", // s
        "\x20\x7c\x22\x22\x04", // t
        "\x3c\x02\x02\x3e",     // u
        "\x38\x04\x02\x04\x38", // v
        "\x3c\x06\x0c\x06\x3c", // w
        "\x22\x14\x08\x14\x22", // x
        "\x39\x05\x06\x3c",     // y
        "\x26\x2a\x2a\x32",     // z - Ascii 122
        "\x10\x7c\x82\x82",     // {
        "\xee",                 // |
        "\x82\x82\x7c\x10",     // }
        "\x40\x80\x40\x80",     // ~
        "\x60\x90\x90\x60"      // Degrees sign - Ascii 127
    ]

    static COS_TABLE = [
        0.000,0.035,0.070,0.105,0.140,0.174,0.208,0.243,0.276,0.310,0.343,0.376,0.408,0.439,0.471,0.501,0.531,0.561,0.589,0.617,0.644,
        0.671,0.696,0.721,0.745,0.768,0.790,0.810,0.830,0.849,0.867,0.884,0.900,0.915,0.928,0.941,0.952,0.962,0.971,0.979,0.985,0.991,
        0.995,0.998,1.000,1.000,0.999,0.997,0.994,0.990,0.984,0.977,0.969,0.960,0.949,0.938,0.925,0.911,0.896,0.880,0.863,0.845,0.826,
        0.806,0.784,0.762,0.739,0.715,0.690,0.664,0.638,0.610,0.582,0.554,0.524,0.494,0.463,0.432,0.400,0.368,0.335,0.302,0.268,0.234,
        0.200,0.166,0.131,0.096,0.062,0.027,-0.008,-0.043,-0.078,-0.113,-0.148,-0.182,-0.217,-0.251,-0.284,-0.318,-0.351,-0.383,-0.415,
        -0.447,-0.478,-0.508,-0.538,-0.567,-0.596,-0.624,-0.651,-0.677,-0.702,-0.727,-0.750,-0.773,-0.795,-0.815,-0.835,-0.854,-0.872,
        -0.888,-0.904,-0.918,-0.931,-0.944,-0.955,-0.964,-0.973,-0.981,-0.987,-0.992,-0.996,-0.998,-1.000,-1.000,-0.999,-0.997,-0.993,
        -0.988,-0.982,-0.975,-0.967,-0.957,-0.947,-0.935,-0.922,-0.908,-0.893,-0.876,-0.859,-0.840,-0.821,-0.801,-0.779,-0.757,-0.733,
        -0.709,-0.684,-0.658,-0.631,-0.604,-0.575,-0.547,-0.517,-0.487,-0.456,-0.424,-0.392,-0.360,-0.327,-0.294,-0.260,-0.226,-0.192,
        -0.158,-0.123,-0.088,-0.053,-0.018];

    static SIN_TABLE = [
        1.000,0.999,0.998,0.994,0.990,0.985,0.978,0.970,0.961,0.951,0.939,0.927,0.913,0.898,0.882,0.865,0.847,0.828,0.808,0.787,
        0.765,0.742,0.718,0.693,0.667,0.641,0.614,0.586,0.557,0.528,0.498,0.467,0.436,0.404,0.372,0.339,0.306,0.272,0.238,0.204,
        0.170,0.135,0.101,0.066,0.031,-0.004,-0.039,-0.074,-0.109,-0.144,-0.178,-0.213,-0.247,-0.280,-0.314,-0.347,-0.379,-0.412,
        -0.443,-0.474,-0.505,-0.535,-0.564,-0.593,-0.620,-0.647,-0.674,-0.699,-0.724,-0.747,-0.770,-0.792,-0.813,-0.833,-0.852,
        -0.870,-0.886,-0.902,-0.916,-0.930,-0.942,-0.953,-0.963,-0.972,-0.980,-0.986,-0.991,-0.995,-0.998,-1.000,-1.000,-0.999,
        -0.997,-0.994,-0.989,-0.983,-0.976,-0.968,-0.959,-0.948,-0.936,-0.924,-0.910,-0.895,-0.878,-0.861,-0.843,-0.823,-0.803,
        -0.782,-0.759,-0.736,-0.712,-0.687,-0.661,-0.635,-0.607,-0.579,-0.550,-0.520,-0.490,-0.459,-0.428,-0.396,-0.364,-0.331,
        -0.298,-0.264,-0.230,-0.196,-0.162,-0.127,-0.092,-0.057,-0.022,0.013,0.048,0.083,0.117,0.152,0.187,0.221,0.255,0.288,
        0.322,0.355,0.387,0.419,0.451,0.482,0.512,0.542,0.571,0.599,0.627,0.654,0.680,0.705,0.730,0.753,0.776,0.797,0.818,0.837,
        0.856,0.874,0.890,0.906,0.920,0.933,0.945,0.956,0.966,0.974,0.981,0.988,0.992,0.996,0.999,1.000];

    // ********** PRIVATE PROPERTIES **********
    _address = 0x3C;
    _i2c = null;
    _rst = null;
    _buffer = null;
    _width = 128;
    _height = 32;
    _x = 0;
    _y = 0;

    /**
     *  Instantiate the display object
     *
     *  @constructor
     *
     *  @param {imp::i2c} i2cBus        - Whichever configured imp I2C bus is to be used for the SSD1306
     *  @param {imp::pin} rstPin        - An imp pin to be used for the RESET line
     *  @param {integer}  [address]     - I2C address of the SSD1306. Default: 0x3C
     *  @param {integer}  [pixelWidth]  - Width of the OLED in pixels. Default: 128
     *  @param {integer}  [pixelHeight] - Height of the OLED in pixels. Default: 32
     *
     *  @returns {instance} The instance
     */
    constructor(i2cBus/*, rstPin*/, address = 0x3C, pixelWidth = 128, pixelHeight = 32) {
        if (i2cBus == null || address == 0) throw "SSD1306OLED() requires a non-null imp I2C bus object and a non-zero I2C address";
        _i2c = i2cBus;
        _address = address << 1;
        //_rst = rstPin;
        _width = pixelWidth;
        _height = pixelHeight;
        _buffer = blob(_width * _height / 8);
    }

    /**
     *  Initialize the display
     */
    function init() {
        //  Toggle the RST pin over 1ms + 10ms
        //_rst.write(1)
        //imp.sleep(0.001)
        //_rst.write(0)
        //imp.sleep(0.01)
        //_rst.write(1);

        // Write the display settings
        local pages = (_height / 8) - 1;
        _write(true, _makeChar(SSD1306_CONSTANTS.DISPLAYOFF))
        _write(true, _makeChar(SSD1306_CONSTANTS.SETDISPLAYCLOCKDIV) + "\x80")
        _write(true, _makeChar(SSD1306_CONSTANTS.SETMULTIPLEX) + _makeChar(_height - 1))
        _write(true, _makeChar(SSD1306_CONSTANTS.SETDISPLAYOFFSET) + "\x00")
        _write(true, _makeChar(SSD1306_CONSTANTS.SETSTARTLINE))
        _write(true, _makeChar(SSD1306_CONSTANTS.CHARGEPUMP) + "\x14")
        _write(true, _makeChar(SSD1306_CONSTANTS.MEMORYMODE) + "\x00")
        _write(true, _makeChar(SSD1306_CONSTANTS.SEGREMAP))
        _write(true, _makeChar(SSD1306_CONSTANTS.COMSCANDEC) + _makeChar(_height == 32 || _height == 16 ? 0x02 : 0x12));
        _write(true, _makeChar(SSD1306_CONSTANTS.SETCONTRAST) + "\x8F")
        _write(true, _makeChar(SSD1306_CONSTANTS.SETPRECHARGE) + "\xF1")
        _write(true, _makeChar(SSD1306_CONSTANTS.SETVCOMDETECT) + "\x40")
        _write(true, _makeChar(SSD1306_CONSTANTS.DISPLAYALLON_RESUME))
        _write(true, _makeChar(SSD1306_CONSTANTS.NORMALDISPLAY))
        _write(true, _makeChar(SSD1306_CONSTANTS.DISPLAYON))
        _write(true, _makeChar(SSD1306_CONSTANTS.COLUMNADDR) + "\x00" + _makeChar(_width - 1));
        _write(true, _makeChar(SSD1306_CONSTANTS.PAGEADDR) + "\x00" + _makeChar(pages));

        // Clear the display
        clear();
        draw();
    }

    /**
     *  Output the buffer to the display
     */
    function draw() {
        _write(false, _buffer.tostring());
    }

    /**
     *  Clear the display buffer
     *  You must call 'draw()' to update the display
     *
     *  @returns {instance} The instance
     */
    function clear() {
        _buffer = blob(_width * _height / 8);
        return this;
    }

    /**
     *  Move the cursor to the home position
     *
     *  @returns {instance} The instance
     */
    function home() {
        move(0, 0);
        return this;
    }

    /**
     *  Move the cursor to the specified position
     *
     *  @param {integer} x - The column value.
     *  @param {integer} y - The row value.
     *
     *  @returns {instance} The instance
     */
    function move(x, y) {
        if (x < 0 || x > (_width - 1) || y < 0 || y > (_height - 1)) {
            server.error("SSD1306OLED.move() co-ordinates out of range");
        } else {
            _x = x;
            _y = y;
        }

        return this;
    }

    /**
     *  Set or unset the pixel at the specified position
     *  You must call 'draw()' to update the display
     *
     *  @param {integer} x        - The column value.
     *  @param {integer} y        - The row value.
     *  @param {integer} [colour] - The colour: 1 (set) or 0 (clear). Default: set
     *
     *  @returns {instance} The instance
     */
    function plot(x, y, color = 1) {
        if (x < 0 || x > (_width - 1) || y < 0 || y > (_height - 1)) {
            server.error("SSD1306OLED.plot() co-ordinates out of range");
        } else {
            // Get the buffer byte holding the pixel
            local byte = _coordsToIndex(x, y);
            local value = _buffer[byte];

            // Get the specific bit representing the pixel
            local bit = y - ((y >> 3) << 3);

            if (color == 1) {
                // Set the pixel
                value = value | (1 << bit);
            } else {
                // Clear the pixel
                value = value & ~(1 << bit);
            }

            // Write the buffer byte back
            _buffer[byte] = value;
        }

        return this;
    }

    /**
     *  Add the specific text to the buffer
     *  You must call 'draw()' to update the display
     *
     *  @param {string} printString - The string to print
     *
     *  @returns {instance} The instance
     */
    function text(printString = "") {
        if (printString == "" || printString.len() == 0) {
            server.error("SSD1306OLED.text() string must not be zero-length");
        } else {
            // Get the cursor position
            local x = _x;
            local y = _y;

            // Run through the string's characters, adding them to the buffer
            for (local i = 0 ; i < printString.len() ; i++) {
                local asc = printString[i] - 32;
                local glyph = CHARSET[asc];
                local c = 0;
                local z = 0;

                for (local j = 0 ; j < glyph.len() + 1; j++) {
                    c = (j == glyph.len() && x < 128) ? 0x00 : _flip(glyph[j]);
                    z = -1;

                    for (local k = 0 ; k < 8 ; k++) {
                        if (((y + k) % 8) == 0 && k != 0) {
                            z = 0
                        } else {
                            z += 1
                        }

                        local b = _coordsToIndex(x , y + k)
                        local v = _buffer[b];
                        local d = 1 << z;
                        if ((c & d) > 0) v = v | d;
                        _buffer[b] = v;
                    }

                    // Move on one pixel
                    x += 1;
                    if (x > _width - 1) {
                        // Right side hit, so move to next text line
                        if (y + 8 < _height) {
                            x = 0;
                            y += 8;
                        } else {
                            break;
                        }
                    }
                }
            }
        }

        return this;
    }

    /**
     *  Draw a line from the current cursor position to the specified point
     *  You must call 'draw()' to update the display
     *
     *  @param {integer} tox         - The column of the end of the line
     *  @param {integer} toy         - The row of the end of the line
     *  @param {integer} [thickness] - The line thickness in pixels. Default: 1
     *  @param {integer} [colour]    - The line colour: 1 (set) or 0 (clear). Default: set
     *
     *  @returns {instance} The instance
     */
    function line(tox, toy, thickness = 1, colour = 1) {
        // Make sure we have a thickness of at least one pixel
        if (thickness < 1) thickness = 1;

        // Set the cursor to the end of the line
        local x = _x;
        local y = _y;
        _x = tox;
        _y = toy;
        if (_x < 0) _x = 0;
        if (_x > _width - 1) _x = _width - 1;
        if (_y < 0) _y = 0;
        if (_y > _height - 1) _y = _height - 1;

        // If necessary swap x and tox so we always scan L-R
        local a = 0;
        if (x > tox) {
            a = x;
            x = tox;
            tox = a;
        }

        // Calculate the line gradient
        local m = (toy - y).tofloat() / (tox - x).tofloat();
        local dy = 0

        // Run for 'thick' times to generate thickness
        for (local j = 0 ; j < thickness ; j++) {
            // Run from x to tox, calculating the y offset at each point
            for (local i = x ; i < tox ; i++) {
                dy = y + (m * (i - x)).tointeger() + j;
                if (i >= 0 && i < _width && dy >= 0 && dy < _height) plot(i, dy, colour);
            }
        }

        return this;
    }

    /**
     *  Draw a circle at the current cursor position of the specified radius
     *  You must call 'draw()' to update the display
     *
     *  @param {integer} radius   - The radius of the circle in pixels
     *  @param {integer} [colour] - Should the circle be filled? Default: false
     *  @param {integer} [colour] - The line colour: 1 (set) or 0 (clear). Default: set
     *
     *  @returns {instance} The instance
     */
    function circle(radius, colour = 1, fill = false) {
        for (local i = 0 ; i < 180 ; i++) {
            local a = _x - (radius * SIN_TABLE[i]).tointeger();
            local b = _y - (radius * COS_TABLE[i]).tointeger();

            if (a >= 0 && a < _width && b >= 0 && b < _height) {
                plot(a, b, colour);

                if (fill) {
                    if (a > _x) {
                        local j = _x;
                        do {
                            plot(j, b, colour)
                            j += 1;
                            if (j >= a) break;
                        } while (true);
                    } else {
                        local j = a + 1;
                        do {
                            plot(j, b, colour);
                            j += 1;
                            if (j > _x) break;
                        } while (true);
                    }
                }
            }
        }

        return this;
    }

    /**
     *  Draw a rectabgle from at the current cursor position to the specified co-ordinates
     *  You must call 'draw()' to update the display
     *
     *  @param {integer} width    - The width of the rectangle in pixels
     *  @param {integer} height   - The height of the rectangle in pixels
     *  @param {integer} [colour] - The line colour: 1 (set) or 0 (clear). Default: set
     *  @param {boolean} [fill]   - Should the rectangle be filled? Default: false
     *
     *  @returns {instance} The instance
     */
    function rect(width, height, colour = 1, fill = false) {
        // Make sure we only draw on the screen
        local x = _x;
        local y = _y;
        if (x + width > _width) width = _width - x;
        if (y + height > _height) height = _height - y;

        for (local i = y ; i < y + height ; i++) {
            for (local j = x ; j < x + width ; j++) {
                plot(j, i, colour);
                if (!fill && x < j && j < x + width - 1 && y < i && i < y + height - 1) plot(j, i, 0);
            }
        }

        return this;
    }

    /**
     *  Sets the entire display to inverse video, or back again,
     *
     *  @param {bool} makeInverss - Should invert the display. Default: true
     */
    function inverse(makeInverse = true) {
        _write(true, _makeChar(makeInverse ? SSD1306_CONSTANTS.INVERTDISPLAY : SSD1306_CONSTANTS.NORMALDISPLAY));
    }

    // ********** PRIVATE FUNCTIONS **********

    function _makeChar(value) {
        // Convert an integer to a char
        return format("%c", value);
    }

    function _write(isCommand, data) {
        // Write a commmand or data to the display via I2C
        local pre = isCommand ? "\x00" : "\x40";
        local r = _i2c.write(_address, pre + data);
        if (r != 0) server.error("I2C read/write: " + r);
    }

    function _coordsToIndex(x, y) {
        // Convert pixel co-ordinates to a bytearray index
        return ((y >> 3) * _width) + x;
    }

    function _indexToCoords(idx) {
        // Convert bytearray index to pixel co-ordinates
        local y = idx >> 4;
        local x = idx - (y << 4);
        return [x, y];
    }

    function _flip(value) {
        // Rotates the character array from the saved state
        local flipped = 0;
        for (local i = 0 ; i < 8 ; i++) {
            if ((value & (1 << i)) > 0) flipped += (1 << (7 - i));
        }
        return flipped;
    }
}


// Class to configure and take readings from Explorer Kit sensors.
// Take readings from temperature humidity and light sensors.
// Use the light level to determine if the door is open (true or false)
// and send the door status, temperature and humidity to the agent 
class SmartFridge {

    // Time in seconds to wait between readings
    static READING_INTERVAL_SEC = 15;

    // The lx level at which we know the door is open
    static LX_THRESHOLD         = 12000;

    // Sensor variables
    tempHumid = null;
    
    i2c = null;
    display = null;
    
    lastTemperature = 0;
    lastHumidity = 0;
    lastDoorOpen = false;

    constructor() {
        // Power save mode will reduce power consumption when the 
        // radio is idle. This adds latency when sending data. 
        imp.setpowersave(true);
        initializeSensors();
        display = SSD1306OLED(i2c, 0x3C, 128, 64);
        display.init();
        display.home();
        display.text("Welcome");
        display.draw();
    }

    function run() {
        // Set up the reading table with a timestamp
        local reading = { "ts" : time() };
        
        // Add temperature and humidity readings
        local result = tempHumid.read();
        if ("temperature" in result) reading.temperature <- result.temperature;
        if ("humidity" in result) reading.humidity <- result.humidity;

        // Check door status using internal LX sensor to 
        // determine if the door is open
        reading.doorOpen <- (hardware.lightlevel() > LX_THRESHOLD);

        local doSend = false;
        // Send readings to the agent
        if (math.abs(reading.temperature - lastTemperature) > 1) {
            doSend = true;
            lastTemperature = reading.temperature;
        }
        if (math.abs(reading.humidity - lastHumidity) > 10) {
            doSend = true;
            lastHumidity = reading.humidity;
        }
        if (reading.doorOpen != lastDoorOpen) {
            doSend = true;
            lastDoorOpen = reading.doorOpen;
        }
        if (doSend) {
            agent.send("reading", reading);
        }
        
        display.clear();
        display.home();
        display.text("Temperature " + reading.temperature.tostring());
        display.move(0,8);
        display.text("Humidity " + reading.humidity.tostring());
        display.move(0,16);
        display.text("Door " + reading.doorOpen.tostring());
        display.draw();

        // Schedule the next reading
        imp.wakeup(READING_INTERVAL_SEC, run.bindenv(this));
    }

    function initializeSensors() {
        // Configure i2c
        local impType = imp.info();
        i2c = null;
        switch(impType.type) {
            case "imp001":
                i2c = hardware.i2c89;
                server.log("imp001 detected, using i2c89");
                break;
            case "imp003":
                i2c = hardware.i2cAB;
                server.log("imp003 detected, using i2cAB");
                break;
            case "imp004m":
                i2c = hardware.i2cQP;
                server.log("imp004m detected, using i2cQP");
                break;
            default:
                server.log("Unsupported imp: " + impType.type);
        }
        i2c.configure(CLOCK_SPEED_400_KHZ);

        // Initialize sensor
        tempHumid = HTS221(i2c);

        // Configure sensor to take readings
        tempHumid.setMode(HTS221_MODE.ONE_SHOT); 
    }
}

// RUNTIME 
// ---------------------------------------------------
server.log("Device running...");

// Initialize application
fridge <- SmartFridge();

// Start reading loop
fridge.run();