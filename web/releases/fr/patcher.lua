-- Trois interventions, une par source de texte :
--   1. le corpus des 167 documents, remplace en bloc par une source regeneree ;
--   2. les chaines noyees dans le code des autres scripts, par substitution ;
--   3. les comparaisons d'enigmes, reecrites pour accepter les reponses FR.
--
-- Les scenes ne sont pas livrees : le GDScript ajoute a texts.gd les fait
-- fabriquer au jeu, au premier lancement, depuis sa propre copie. Le mod ne
-- transporte donc aucun fichier du jeu et ne vise aucune build en particulier.
local utils = require("gdpatch.utils")
local dir = GDPatch.get_mod_directory()

GDPatch.patch_script_as_text("Scripts/texts.gdc", function(ctx, src)
	local f = io.open(dir .. "/texts.gd", "r")
	if not f then
		print("texts.gd introuvable, corpus laisse en anglais")
		return src
	end
	local fr = f:read("a")
	f:close()
	-- Seul le patcher connait le chemin du mod ; le GDScript en a besoin pour y
	-- ecrire les scenes qu'il fabrique.
	--
	-- Sous Windows ce chemin porte des antislashs, et "C:\Users\..." donne \U, \m,
	-- \f : des echappements invalides en GDScript. Le script entier etait rejete,
	-- donc ni corpus traduit ni scenes fabriquees -- en silence, comme toujours.
	-- Godot accepte les slashes avant sur toutes les plateformes, on normalise.
	local chemin = dir:gsub("\\", "/")
	fr = fr:gsub("@@MOD_DIR@@", (chemin:gsub("%%", "%%%%")))
	print("CORPUS-FR " .. #fr .. " octets")
	return fr
end)


local chaines = dofile(dir .. "/strings.lua")
for script, paires in pairs(chaines) do
	GDPatch.patch_script_as_text(script, function(ctx, src)
		local out, faits, manques = src, 0, 0
		for _, paire in ipairs(paires) do
			local remplace, n = out:gsub(utils.escape(paire[1]), utils.escape(paire[2], true))
			if n > 0 then
				out = remplace
				faits = faits + 1
			else
				manques = manques + 1
				print("MANQUE " .. ctx.path .. " :: " .. paire[1]:sub(1, 50))
			end
		end
		print("CHAINES " .. ctx.path .. " : " .. faits .. " ok, " .. manques .. " manques")
		return out
	end)
end

local reponses = dofile(dir .. "/answers.lua")
for script, paires in pairs(reponses.remplacements) do
	GDPatch.patch_script_as_text(script, function(ctx, src)
		local out = src
		for _, paire in ipairs(paires) do
			local remplace, n = out:gsub(utils.escape(paire[1]), utils.escape(paire[2], true))
			if n > 0 then out = remplace
			else print("ENIGME NON APPLIQUEE " .. ctx.path) end
		end
		if reponses.aides[script] then out = out .. reponses.aides[script] end
		return out
	end)
end
