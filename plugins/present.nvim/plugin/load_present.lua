vim.api.nvim_create_user_command("PresentStart", function() 
  --- By putting the require in this function, then we get "lazy loaded", because we don't actually load our 
  --- module until someone calls PresentStart. Had we put it above, we would've automatically loaded our module immedietely. 
  --- Its mindful to do this
  require("present").start_presentation()
end, {})
