-- проверка таблицы на наличие элемента в таблице
function HashInTable_HIT(hit_hash, table_name)
    for k, v in pairs(table_name) do 
        if (hit_hash == v) then 
            return true 
        end 
    end 
    return false 
end 

-- основной тред скрипта
Citizen.CreateThread(function()
	-- переменные для удобства и разгрузки клиента

	-- убирает автоперезарядку, автосмену оружия, оставляет фонарик включенным
	SetWeaponsNoAutoreload(true)
    SetWeaponsNoAutoswap(true)
    SetFlashLightKeepOnWhileMoving(true)
	
	while true do
		Citizen.Wait(0)
		local ped = GetPlayerPed(-1)
		local weapon = GetSelectedPedWeapon(ped)
		-- проверка на голограф. для снайпы mk2
		local getComp = HasPedGotWeaponComponent(ped, GetHashKey('WEAPON_MARKSMANRIFLE_MK2'), GetHashKey('COMPONENT_AT_SIGHTS'))

		-- проверка на снайперку
		if IsHudComponentActive(14) then
			if not(HashInTable_HIT(GetSelectedPedWeapon(ped), scopedWeapons)) then
				HideHudComponentThisFrame(14)
			end
		end
		-- проверка для снапы мк2

		if IsHudComponentActive(14) then
			if GetSelectedPedWeapon(ped) == GetHashKey('WEAPON_MARKSMANRIFLE_MK2') then
				if getComp == 1 then 
					HideHudComponentThisFrame(14)
				else
					ShowHudComponentThisFrame(14)
				end
			end
		end

		-- выключается ближний бой с оружием
		if IsPedArmed(ped, 6) then
			DisableControlAction(1, 140, true)
			DisableControlAction(1, 141, true)
			DisableControlAction(1, 142, true)
		end
		
		-- тряски для пушек
		if HashInTable_HIT(GetSelectedPedWeapon(ped), small_recoil) then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.05)
			end
		end

		if HashInTable_HIT(GetSelectedPedWeapon(ped), medium_recoil) then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.09)
			end
		end

		if HashInTable_HIT(GetSelectedPedWeapon(ped), heavy_recoil) then
			if IsPedShooting(ped) then
				ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.2)
			end
		end
		
		-- бесконечный огнетушитель
		if weapon == GetHashKey("WEAPON_FIREEXTINGUISHER") then		
			if IsPedShooting(ped) then
				SetPedInfiniteAmmo(ped, true, GetHashKey("WEAPON_FIREEXTINGUISHER"))
			end
		end
	end
end)