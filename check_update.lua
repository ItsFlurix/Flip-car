if Config.enableUpdates then
    local function GitHubUpdate()
        PerformHttpRequest('https://raw.githubusercontent.com/ItsFlurix/Flip-car/main/fxmanifest.lua',
            function(error, result, headers)
                local actual = GetResourceMetadata(GetCurrentResourceName(), 'version')

                if not result then
                    print("^6Flip-car^7 - No se pudo verificar la versión")
                end

                local version = string.sub(result, string.find(result, "%d.%d.%d"))

                if tonumber((version:gsub("%D+", ""))) > tonumber((actual:gsub("%D+", ""))) then
                    print('^6Flip-car^7 - Hay una nueva versión disponible: ^2' ..
                            version .. '^0. Estás utilizando la versión ^1' .. actual .. '^0')
                    print('^6Flip-car^7 - Descarga la nueva versión en: https://github.com/ItsFlurix/Flip-car')
                else
                    print('^6Flip-car^7 - Estás utilizando la última versión del script.')
                end
            end)
    end
    GitHubUpdate()
end
