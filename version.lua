if Flipcar.Version then
    local function GitHubUpdate()
      PerformHttpRequest('https://raw.githubusercontent.com/ItsFlurix/Flip-car/fxmanifest.lua',
        function(error, result, headers)
          local actual = GetResourceMetadata(GetCurrentResourceName(), 'version')
  
          if not result then print("^6Flip - Car^7 -  version couldn't be checked") end
  
          local version = string.sub(result, string.find(result, "%d.%d.%d"))
  
          if tonumber((version:gsub("%D+", ""))) > tonumber((actual:gsub("%D+", ""))) then
            print('^6Flip - Car^7  - The version ^2' ..
            version .. '^0 is available, you are still using version ^1' .. actual .. '^0')
            print('^6Flip - Car^7  - Download the new version at: https://github.com/ItsFlurix/Flip-car')
          else
            print('^Flip - Car^7 - You are using the latest version of the script.')
          end
        end)
    end
    GitHubUpdate()
  end  