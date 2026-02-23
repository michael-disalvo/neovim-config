local parse = require("present")._parse_slides

describe("present.parse_slides", function()

  it("should parse an empty file", function()
    assert.are.same({
      slides = {}
    }, parse {})
  end)

  it("should parse a file with one slide", function()
    assert.are.same({
        slides = {
          {
            title = "# This is the first slide",
            body = {
              "This is the body"
            },
            blocks = {}
          }
        }
      },
      parse {
        "# This is the first slide",
        "This is the body"
      })
    end)
    
    it("should parse a file with one slide and a block", function()
      local result = parse {
          "# This is the first slide",
          "This is the body",
          "```lua",
          "print('hi')",
          "```"
        }

      local title = "# This is the first slide"

      assert.are.same(#result.slides, 1)
      assert.are.same(result.slides[1].title, title)

      local body = {
        "This is the body",
        "```lua",
        "print('hi')",
        "```"
      }

      assert.are.same(result.slides[1].body, body)

      local block = {
        language = "lua",
        body = "print('hi')"
      }

      assert.are.same(result.slides[1].blocks[1], block)

    end)
end)


