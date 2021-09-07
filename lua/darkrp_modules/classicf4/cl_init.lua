/*
	
	A quick remake of the old DarkRP F4 menu
	
	made for gmod.club Classic DarkRP
	by 0xymoron
	
*/

local F4 = {}

F4.Config = {

	GangLeaders = { // gang leader jobs who should be able to set the agenda
		"Mob Boss",
		"Crip Leader",
		"Blood Leader",
	},
	Mayor = "Mayor", // mayor job
	
	Header = "gmod.club | Classic DarkRP",

}

F4.Menu = {}
F4.Menu.Tabs = {}

local scrw, scrh = ScrW(), ScrH()

function F4.Menu.Frame()
	
	F4.Frame = vgui.Create( "DFrame" )
	F4.Frame:SetTitle( F4.Config.Header )
	F4.Frame:SetSize( scrw * 0.5, scrh * 0.65 ) 
	F4.Frame:Center()	
	F4.Frame:ShowCloseButton( false )
	F4.Frame:MakePopup()

	F4.Frame.OnKeyCodePressed = function( self, key )

		if key == KEY_F4 then
	
			F4.Frame:SetVisible( false )
	
		end
	
	end
	
	local close = vgui.Create( "DButton", F4.Frame )
	close:SetSize( 16, 16 )
	close:SetPos( F4.Frame:GetWide() - 20, 4 )
	close:SetText( "" )
	
	local closeMat = Material( "icon16/cancel.png" )
	close.Paint = function( self, w, h )
	
		surface.SetMaterial( closeMat )
		
		surface.DrawTexturedRect( 0, 0, w, h )
	
	end
	
	close.DoClick = function( self ) self:GetParent():SetVisible( false ) end
	
	local sheet = vgui.Create( "DPropertySheet", F4.Frame )
	sheet:Dock( FILL )
	
	F4.Menu.Tabs.Main( sheet )
	F4.Menu.Tabs.Jobs( sheet )
	F4.Menu.Tabs.Entities( sheet )
	
end

function F4.Menu.Tabs.Main( parent )

	local frame = F4.Frame
	
	local panel = vgui.Create( "DPanel", parent )
	panel:SetSize( frame:GetWide(), frame:GetTall() - 70 )
	panel.Paint = function( self, w, h ) end

	local scroll = vgui.Create( "DScrollPanel", panel )
	scroll:SetPos( 0, 0 )
	scroll:SetSize( panel:GetWide(), panel:GetTall() )
	scroll:GetVBar():SetWide( 0 )
	
	// Money Commands
	local money = vgui.Create( "DCollapsibleCategory" )
	money:SetLabel( "Money" )
	money:Dock( TOP )
	money:DockMargin( 0, 5, 0, 5 )
	money.Paint = function( self, w, h ) draw.RoundedBox( 6, 0, 0, w, h, Color( 0, 150, 0 ) ) end
	
	local moneypanel = vgui.Create( "DPanelList" )
	moneypanel:SetSpacing( 0 )
	moneypanel:EnableHorizontal( false )
	moneypanel:EnableVerticalScrollbar( true )	

	local give = moneypanel:Add( "DButton" )
	give:SetText( DarkRP.getPhrase( "give_money" ) )
	give.DoClick = function() Derma_StringRequest( "Amount of money", "How much money do you want to give?", "", function( a ) RunConsoleCommand( "darkrp", "give", a ) end ) end
	give:Dock( TOP )
	
	local drop = moneypanel:Add( "DButton" )
	drop:SetText( DarkRP.getPhrase( "drop_money" ) )
	drop.DoClick = function() Derma_StringRequest( "Amount of money", "How much money do you want to drop?", "", function( a ) RunConsoleCommand( "darkrp", "dropmoney", a ) end ) end
	drop:Dock( TOP )
	
	money:SetContents( moneypanel )
	
	// Other Commands
	local commands = vgui.Create( "DCollapsibleCategory" )
	commands:SetLabel( "Actions" )
	commands:Dock( TOP )
	commands:DockMargin( 0, 5, 0, 5 )
	commands.Paint = function( self, w, h ) draw.RoundedBox( 6, 0, 0, w, h, Color( 70, 70, 70 ) ) end
	
	local cmdpanel = vgui.Create( "DPanelList" )
	cmdpanel:SetSpacing( 0 )
	cmdpanel:EnableHorizontal( false )
	cmdpanel:EnableVerticalScrollbar( true )	
	
	local rpnamelabel = cmdpanel:Add( "DLabel" )
	rpnamelabel:SetText( DarkRP.getPhrase( "change_name" ) )
	rpnamelabel.paint = function( self, w, h )
		draw.RoundedBox( 1, 0, 0, w, h, Color( 5, 5, 5 ) )
	end	
	rpnamelabel:Dock( TOP )
	
	local rpname = cmdpanel:Add( "DTextEntry" )
	rpname:SetText( LocalPlayer():Nick() )
	rpname.OnEnter = function( self ) RunConsoleCommand( "darkrp", "rpname", tostring( self:GetValue() ) ) end
	rpname:Dock( TOP )

	local joblabel = cmdpanel:Add( "DLabel" )
	joblabel:SetText( DarkRP.getPhrase( "set_custom_job" ) )
	joblabel.paint = function( self, w, h )
		draw.RoundedBox( 1, 0, 0, w, h, Color( 5, 5, 5 ) )
	end	
	joblabel:Dock( TOP )
	
	local customjob = cmdpanel:Add( "DTextEntry" )
	customjob:SetText( LocalPlayer():getDarkRPVar( "job" ) or "" )
	customjob.OnEnter = function( self ) RunConsoleCommand( "darkrp", "job", tostring( self:GetValue() ) ) end
	customjob:Dock( TOP )
	
	local dropwep = cmdpanel:Add( "DButton" )
	dropwep:SetText( DarkRP.getPhrase( "drop_weapon" ) )
	dropwep.DoClick = function() RunConsoleCommand( "darkrp", "drop" ) end
	dropwep:Dock( TOP )
	
	local unowndoors = cmdpanel:Add( "DButton" )
	unowndoors:SetText( "Sell all of your doors" )
	unowndoors.DoClick = function() RunConsoleCommand( "darkrp", "unownalldoors" ) end
	unowndoors:Dock( TOP )
	
	commands:SetContents( cmdpanel )
	
	// Gang Commands
	local function gangCommands()
	
		local gang = vgui.Create( "DCollapsibleCategory" )
		gang:SetLabel( "Gang leader options" )
		gang:Dock( TOP )
		gang:DockMargin( 0, 5, 0, 5 )
		gang.Paint = function( self, w, h ) draw.RoundedBox( 6, 0, 0, w, h, team.GetColor( LocalPlayer():Team() ) ) end
		
		local gangpanel = vgui.Create( "DPanelList" )
		gangpanel:SetSpacing( 0 )
		gangpanel:EnableHorizontal( false )
		gangpanel:EnableVerticalScrollbar( true )		

		local agendalabel = gangpanel:Add( "DLabel" )
		agendalabel:SetText( DarkRP.getPhrase( "set_agenda" ) )
		agendalabel.paint = function( self, w, h )
			draw.RoundedBox( 1, 0, 0, w, h, Color( 5, 5, 5 ) )
		end	
		agendalabel:Dock( TOP )
		
		local agenda = gangpanel:Add( "DTextEntry" )
		agenda:SetText( LocalPlayer():getDarkRPVar( "agenda" ) or "" )
		agenda.OnEnter = function( self ) RunConsoleCommand( "darkrp", "agenda", tostring( self:GetValue() ) ) end
		agenda:Dock( TOP )		
		
		gang:SetContents( gangpanel )
		
		return gang
		
	end
	
	// CP Commands
	local function cpCommands()
		
		local cp = vgui.Create( "DCollapsibleCategory" )
		cp:SetLabel( "Police options" )
		cp:Dock( TOP )
		cp:DockMargin( 0, 5, 0, 5 )
		cp.Paint = function( self, w, h ) draw.RoundedBox( 6, 0, 0, w, h, team.GetColor( LocalPlayer():Team() ) ) end
		
		local cppanel = vgui.Create( "DPanelList" )
		cppanel:SetSpacing( 0 )
		cppanel:EnableHorizontal( false )
		cppanel:EnableVerticalScrollbar( true )	
		
		local search = cppanel:Add("DButton")
		search:SetText( DarkRP.getPhrase("request_warrant") )
		search.DoClick = function()			
			local menu = DermaMenu()
			for k, v in next, player.GetAll() do			
				if !v:getDarkRPVar( "warrant" ) and v != LocalPlayer() then				
					menu:AddOption( v:Nick(), function()
						Derma_StringRequest( "Warrant", "Why do you want to search warrant " .. v:Nick() .. "?", nil,
							function( a )
								RunConsoleCommand( "darkrp", "warrant", v:Nick(), a )
							end,
						function() end )
					end )
				end
			end
			menu:Open()
		end
		search:Dock( TOP )
		
		local wanted = cppanel:Add("DButton")
		wanted:SetText( DarkRP.getPhrase( "searchwarrantbutton" ) )
		wanted.DoClick = function()			
			local menu = DermaMenu()
			for k, v in next, player.GetAll() do			
				if !v:getDarkRPVar( "wanted" ) and v != LocalPlayer() then				
					menu:AddOption( v:Nick(), function()
						Derma_StringRequest( "Wanted", "Why do you want to make " .. v:Nick() .. " wanted?", nil,
							function( a )
								RunConsoleCommand( "darkrp", "wanted", v:Nick(), a )
							end,
						function() end )
					end )
				end
			end
			menu:Open()
		end
		wanted:Dock( TOP )
		
		local unwanted = cppanel:Add("DButton")
		unwanted:SetText( DarkRP.getPhrase( "unwarrantbutton" ) )
		unwanted.DoClick = function()			
			local menu = DermaMenu()
			for k, v in next, player.GetAll() do			
				if v:getDarkRPVar( "wanted" ) and v != LocalPlayer() then				
					menu:AddOption( v:Nick(), function() RunConsoleCommand( "darkrp", "unwanted", v:Nick() ) end )
				end
			end
			menu:Open()
		end
		unwanted:Dock( TOP )
		
		local givelicense = cppanel:Add( "DButton" )
		givelicense:SetText( DarkRP.getPhrase( "give_license_lookingat" ) )
		givelicense.DoClick = function() RunConsoleCommand( "darkrp", "givelicense" ) end
		givelicense:Dock( TOP )
		
		cp:SetContents( cppanel )
		
		return cp
	
	end
	
	local function mayorOptions()
		
		local mayor = vgui.Create( "DCollapsibleCategory" )
		mayor:SetLabel( "Mayor options" )
		mayor:Dock( TOP )
		mayor:DockMargin( 0, 5, 0, 5 )
		mayor.Paint = function( self, w, h ) draw.RoundedBox( 6, 0, 0, w, h, team.GetColor( LocalPlayer():Team() ) ) end
		
		local mayorpanel = vgui.Create( "DPanelList" )
		mayorpanel:SetSpacing( 0 )
		mayorpanel:EnableHorizontal( false )
		mayorpanel:EnableVerticalScrollbar( true )	
	
		local lockdown = mayorpanel:Add( "DButton" )
		lockdown:SetText( DarkRP.getPhrase( "initiate_lockdown" ) )
		lockdown.DoClick = function() RunConsoleCommand( "darkrp", "lockdown" ) end
		lockdown:Dock( TOP )	
	
		local unlockdown = mayorpanel:Add( "DButton" )
		unlockdown:SetText( DarkRP.getPhrase( "stop_lockdown" ) )
		unlockdown.DoClick = function() RunConsoleCommand( "darkrp", "unlockdown" ) end
		unlockdown:Dock( TOP )		
	
		local lottery = mayorpanel:Add( "DButton" )
		lottery:SetText( DarkRP.getPhrase( "start_lottery" ) )
		lottery.DoClick = function() Derma_StringRequest( "Lottery", "Enter lottery joining price", nil, function( a ) RunConsoleCommand( "darkrp", "lottery", a ) end ) end
		lottery:Dock( TOP )	
		
		local placelaws = mayorpanel:Add( "DButton" )
		placelaws:SetText( "Place a screen containing the laws" )
		placelaws.DoClick = function() RunConsoleCommand( "darkrp", "placelaws" ) end
		placelaws:Dock( TOP )
		
		local addlaw = mayorpanel:Add( "DButton" )
		addlaw:SetText( "Add a law" )
		addlaw.DoClick = function() Derma_StringRequest( "Add a law", "Type the law you would like to add here.", "", function( a ) RunConsoleCommand( "darkrp", "addlaw", a ) end ) end
		addlaw:Dock( TOP )	
		
		local removelaw = mayorpanel:Add( "DButton" )
		removelaw:SetText( "Remove a law" )
		removelaw.DoClick = function() Derma_StringRequest( "Add a law", "Enter the number of the law you would like to remove here.", "", function( a ) RunConsoleCommand( "darkrp", "removelaw", a ) end ) end
		removelaw:Dock( TOP )	
		
		mayor:SetContents( mayorpanel )
	
		return mayor
		
	end
	
	// end of main menu :^)
	
	scroll:AddItem( money )
	scroll:AddItem( commands )

	local job = team.GetName( LocalPlayer():Team() )
	
	if job == F4.Config.Mayor then
	
		scroll:AddItem( mayorOptions() )
	
	end
	
	if LocalPlayer():isCP() then
		
		scroll:AddItem( cpCommands() )
		
	end
	
	if table.HasValue( F4.Config.GangLeaders, team.GetName( LocalPlayer():Team() ) ) then
		scroll:AddItem( gangCommands() )
	end
	
	parent:AddSheet( "Commands", panel, "icon16/plugin.png" )

end

function F4.Menu.Tabs.Jobs( parent )
	
	local frame = F4.Frame
	
	local panel = vgui.Create( "DPanel", parent )
	panel:SetSize( frame:GetWide(), frame:GetTall() - 70 )
	panel.Paint = function( self, w, h ) end

	local scroll = vgui.Create( "DScrollPanel", panel )
	scroll:SetPos( 0, 0 )
	scroll:SetSize( panel:GetWide() * 0.5, panel:GetTall() )
	scroll:GetVBar():SetWide( 0 )
	
	local infopanel = vgui.Create( "DPanelList", panel )
	infopanel:SetPos( scroll:GetWide() + 5, 0 )
	infopanel:SetSize( ( panel:GetWide() - scroll:GetWide() ) - 10, panel:GetTall() )
	infopanel.Paint = function( self, w, h )
	
		draw.RoundedBox( 6, 0, 0, w, h, Color( 85, 85, 85 ) )
	
	end
	
	/*
		
		Job Info Panel
		
	*/
	
	local Info = {} // thanks old darkrp
	local getWepName = fn.FOr{fn.FAnd{weapons.Get, fn.Compose{fn.Curry(fn.GetValue, 2)("PrintName"), weapons.Get}}, fn.Id}
	local getWeaponNames = fn.Curry(fn.Map, 2)(getWepName)
	local weaponString = fn.Compose{fn.Curry(fn.Flip(table.concat), 2)("\n"), fn.Curry(fn.Seq, 2)(table.sort), getWeaponNames, table.Copy}
	
	local function updateJobPanel( job )

		if job == false then
			
			infopanel:Clear()
			
			Info = {}
			
			return
		
		end
		
		Info[1] = DarkRP.getPhrase("job_name") .. job.name
		Info[2] = DarkRP.getPhrase("job_description") .. job.description
		
		local weps = weaponString( job.weapons )
		weps = weps != "" && weps or DarkRP.getPhrase( "no_extra_weapons" )
		Info[3] = DarkRP.getPhrase("job_weapons") .. weps	
		
		infopanel:Clear()
		
		if istable( Info ) && #Info > 0 then
		
			for k, v in ipairs( Info ) do
				
				local text = DarkRP.textWrap( DarkRP.deLocalise( v or "" ):gsub( "\t", "" ), "Trebuchet20", infopanel:GetWide() - 20 )	
				
				local label = vgui.Create( "DLabel" )
				label:SetText( text )
				label:SetFont( "Trebuchet20" )
				label:SetTextColor( color_white )
				label:SizeToContents()
				
				if label:IsValid() then infopanel:AddItem( label ) end
			
			end
		
		end
		
	end
	
	/*
		
		Jobs
		
	*/
	
	local categories = DarkRP.getCategories().jobs

	for i = 1, #categories do
	
		local category = categories[i]
		
		if #category.members == 0 then continue end
		
		local cat = scroll:Add( "DCollapsibleCategory" )
		cat:SetLabel( category.name )
		cat:Dock( TOP )
		cat:DockMargin( 0, 0, 0, 5 )
		
		cat:GetChildren()[1].Paint = function( self, w, h )
		
			draw.RoundedBox( 6, 0, 0, w, h, category.color )
		
		end
		
		local joblist = vgui.Create( "DPanelList" )
		joblist:SetSpacing( 0 )
		joblist:EnableHorizontal( true )
		joblist:EnableVerticalScrollbar( true )	
		cat:SetContents( joblist )
		
		local jobs = RPExtraTeams

		for k, v in ipairs( jobs ) do

			if v.category != category.name then continue end
			
			local vip = v.vip or false
			
			if v.customCheck then vip = true end
			
			local size = scroll:GetWide() * 0.25

			local jobicon = vgui.Create( "SpawnIcon" )
			
			local iconmodel = v.model
			if istable( v.model ) then iconmodel = table.Random( v.model ) end
			jobicon:SetModel( iconmodel )
			
			jobicon:SetSize( size, size )
			
			jobicon:SetToolTip()
			
			jobicon.OnCursorEntered = function( self ) updateJobPanel( v ) end
			
			jobicon.OnCursorExited = function( self ) updateJobPanel( false ) end
			
			jobicon.Paint = function( s, w, h )
			
				draw.RoundedBox( 0, 0, 0, w, h, v.color )

			end
			
			local vipicon = Material( "icon16/star.png" )
			local vipiconsize = 16
			local oldpaint = jobicon.PaintOver
			jobicon.PaintOver = function( self, w, h )
				
				if vip then
				
					surface.SetMaterial( vipicon )
					
					surface.DrawTexturedRect( w - vipiconsize - 2, 2, vipiconsize, vipiconsize )
			
				end

				oldpaint( self, w, h )
			
			end
			
			jobicon.DoClick = function() // thanks again old darkrp
			
				local function doChatCommand( panel )	
				
					if v.vote then				
					
						if LocalPlayer():IsAdmin() then	
						
							local menu = DermaMenu()
							menu:AddOption( "Vote", function() RunConsoleCommand( "darkrp", "vote" .. v.command ) panel:Close() end )
							menu:AddOption( "Do not vote", function() RunConsoleCommand( "darkrp", v.command ) panel:Close() end )
							menu:Open()			
							
						else	
							
							RunConsoleCommand( "darkrp", "vote" .. v.command )								
							panel:Close()
							
						end

					else
					
						RunConsoleCommand( "darkrp", v.command )	
						panel:Close()
						
					end
					
				end

				if istable( v.model ) and #v.model > 0 then
				
					frame:Close()
					
					local modelframe = vgui.Create("DFrame")
					modelframe:SetTitle("Choose model")
					modelframe:SetVisible(true)
					modelframe:MakePopup()

					local levels = 1
					local IconsPerLevel = math.floor(ScrW()/64)

					while #v.model * (64/levels) > ScrW() do
						levels = levels + 1
					end
					modelframe:SetSize(math.Min(#v.model * 64, IconsPerLevel*64), math.Min(90+(64*(levels-1)), ScrH()))
					modelframe:Center()

					local CurLevel = 1
					for k,v in pairs( v.model ) do
						local icon = vgui.Create("SpawnIcon", modelframe)
						if (k-IconsPerLevel*(CurLevel-1)) > IconsPerLevel then
							CurLevel = CurLevel + 1
						end
						icon:SetPos((k-1-(CurLevel-1)*IconsPerLevel) * 64, 25+(64*(CurLevel-1)))
						icon:SetModel(v)
						icon:SetSize(64, 64)
						icon:SetToolTip()
						icon.DoClick = function()
							DarkRP.setPreferredJobModel( k, v )
							doChatCommand( modelframe )
						end
					end
					
				else
				
					doChatCommand( frame )
					
				end
				
			end
			
			if jobicon:IsValid() then joblist:AddItem( jobicon ) end
		
		end

	end
	
	parent:AddSheet( "Jobs", panel, "icon16/user_gray.png" )
	
end

function F4.Menu.Tabs.Entities( parent )

	local frame = F4.Frame
	
	local panel = vgui.Create( "DPanel", parent )
	panel:SetSize( frame:GetWide(), frame:GetTall() - 70 )
	panel.Paint = function( self, w, h ) end

	local scroll = vgui.Create( "DScrollPanel", panel )
	scroll:SetPos( 0, 0 )
	scroll:SetSize( panel:GetWide(), panel:GetTall() )
	scroll:GetVBar():SetWide( 0 )
	
	local entities = DarkRP.getCategories().entities
	
	for i = 1, #entities do
	
		local category = entities[i]
		local members = {}

		for k, v in ipairs( category.members ) do
		
			if v.allowed && istable( v.allowed ) && !table.HasValue( v.allowed, LocalPlayer():Team() ) then continue end
			if v.customCheck then v.vip = true end
			
			members[k] = v
			
		end
		
		if #members == 0 then continue end
		
		local cat = scroll:Add( "DCollapsibleCategory" )
		cat:SetLabel( category.name )
		cat:Dock( TOP )
		cat:DockMargin( 0, 0, 0, 5 )
		
		cat:GetChildren()[1].Paint = function( self, w, h )
		
			draw.RoundedBox( 6, 0, 0, w, h, category.color )
		
		end
		
		local entlist = vgui.Create( "DPanelList" )
		entlist:SetSpacing( 0 )
		entlist:EnableHorizontal( true )
		entlist:EnableVerticalScrollbar( true )	
		cat:SetContents( entlist )
		
		local function AddIcon( v )

			local size = scroll:GetWide() * 0.1
			local icon = vgui.Create( "SpawnIcon" )
			
			icon:SetModel( v.model )			
			icon:SetSize( size, size )			
			icon:SetToolTip( v.name .. " " .. DarkRP.formatMoney( v.price ) )

			icon.Paint = function( s, w, h )
			
				draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 45, 45, 45 ) )

			end

			local vipicon = Material( "icon16/star.png" )
			local vipiconsize = 16
			local oldpaint = icon.PaintOver
			icon.PaintOver = function( self, w, h )

				if v.vip then
				
					surface.SetMaterial( vipicon )
					
					surface.DrawTexturedRect( w - vipiconsize - 2, 2, vipiconsize, vipiconsize )
			
				end
			
				surface.SetDrawColor( category.color )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
			
				return oldpaint( self, w, h )
			
			end

			icon.DoClick = function( self )
			
				RunConsoleCommand( "darkrp", v.cmd )
			
			end
			
			if icon:IsValid() then entlist:AddItem( icon ) end
			
		end

		for k, v in ipairs( members ) do

			AddIcon( v )
			
		end
		
	end
	
	local ammo = DarkRP.getCategories().ammo

	for i = 1, #ammo do
	
		local category = ammo[i]
		local members = {}
		
		for k, v in ipairs( category.members ) do
		
			if v.allowed && istable( v.allowed ) && !table.HasValue( v.allowed, LocalPlayer():Team() ) then continue end
			if v.customCheck && !v.customCheck( LocalPlayer() ) then continue end
			
			members[k] = v
			
		end
		
		if #members == 0 then continue end
		
		local cat = scroll:Add( "DCollapsibleCategory" )
		cat:SetLabel( "Ammo" )
		cat:Dock( TOP )
		cat:DockMargin( 0, 0, 0, 5 )
		
		cat:GetChildren()[1].Paint = function( self, w, h )
		
			draw.RoundedBox( 6, 0, 0, w, h, category.color )
		
		end
		
		local entlist = vgui.Create( "DPanelList" )
		entlist:SetSpacing( 0 )
		entlist:EnableHorizontal( true )
		entlist:EnableVerticalScrollbar( true )	
		cat:SetContents( entlist )
		
		local function AddIcon( v )

			local size = scroll:GetWide() * 0.1
			local icon = vgui.Create( "SpawnIcon" )
			
			icon:SetModel( v.model )			
			icon:SetSize( size, size )			
			icon:SetToolTip( v.name .. " " .. DarkRP.formatMoney( v.price ) )

			icon.Paint = function( s, w, h )
			
				draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 45, 45, 45 ) )

			end
			
			local oldpaint = icon.PaintOver
			icon.PaintOver = function( self, w, h )
			
				surface.SetDrawColor( category.color )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
			
				return oldpaint( self, w, h )
			
			end
			
			icon.DoClick = function( self )
			
				RunConsoleCommand( "darkrp", "buyammo", v.ammoType )
			
			end
			
			if icon:IsValid() then entlist:AddItem( icon ) end
			
		end

		for k, v in ipairs( members ) do

			AddIcon( v )
			
		end
		
	end
		
	
	local weps = DarkRP.getCategories().weapons
	
	for i = 1, #weps do
	
		local category = weps[i]
		local members = {}
		
		for k, v in ipairs( category.members ) do
		
			if v.allowed && istable( v.allowed ) && !table.HasValue( v.allowed, LocalPlayer():Team() ) then continue end
			if v.customCheck && !v.customCheck( LocalPlayer() ) then continue end
			
			members[k] = v
			
		end
		
		if #members == 0 then continue end
		
		local cat = scroll:Add( "DCollapsibleCategory" )
		cat:SetLabel( category.name )
		cat:Dock( TOP )
		cat:DockMargin( 0, 0, 0, 5 )
		
		cat:GetChildren()[1].Paint = function( self, w, h )
		
			draw.RoundedBox( 6, 0, 0, w, h, category.color )
		
		end
		
		local entlist = vgui.Create( "DPanelList" )
		entlist:SetSpacing( 0 )
		entlist:EnableHorizontal( true )
		entlist:EnableVerticalScrollbar( true )	
		cat:SetContents( entlist )
		
		local function AddIcon( v )

			local size = scroll:GetWide() * 0.1
			local icon = vgui.Create( "SpawnIcon" )
			
			icon:SetModel( v.model )			
			icon:SetSize( size, size )			
			icon:SetToolTip( v.name .. " single " .. DarkRP.formatMoney( v.pricesep ) )

			icon.Paint = function( s, w, h )
			
				draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 45, 45, 45 ) )

			end
			
			local oldpaint = icon.PaintOver
			icon.PaintOver = function( self, w, h )
			
				surface.SetDrawColor( category.color )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
			
				return oldpaint( self, w, h )
			
			end
			
			icon.DoClick = function( self )
			
				RunConsoleCommand( "darkrp", "buy", v.name )
			
			end
			
			if icon:IsValid() then entlist:AddItem( icon ) end
			
		end

		for k, v in ipairs( members ) do

			AddIcon( v )
			
		end
		
	end
	
	local shipments = DarkRP.getCategories().shipments
	
	for i = 1, #shipments do
	
		local category = shipments[i]
		local members = {}
		
		for k, v in ipairs( category.members ) do
		
			if v.allowed && istable( v.allowed ) && !table.HasValue( v.allowed, LocalPlayer():Team() ) then continue end
			if v.customCheck && !v.customCheck( LocalPlayer() ) then continue end
			
			members[k] = v
			
		end
		
		if #members == 0 then continue end
		
		local cat = scroll:Add( "DCollapsibleCategory" )
		cat:SetLabel( category.name .. " Shipments" )
		cat:Dock( TOP )
		cat:DockMargin( 0, 0, 0, 5 )
		
		cat:GetChildren()[1].Paint = function( self, w, h )
		
			draw.RoundedBox( 6, 0, 0, w, h, category.color )
		
		end
		
		local entlist = vgui.Create( "DPanelList" )
		entlist:SetSpacing( 0 )
		entlist:EnableHorizontal( true )
		entlist:EnableVerticalScrollbar( true )	
		cat:SetContents( entlist )
		
		local function AddIcon( v )

			local size = scroll:GetWide() * 0.1
			local icon = vgui.Create( "SpawnIcon" )
			
			icon:SetModel( v.model )			
			icon:SetSize( size, size )			
			icon:SetToolTip( v.name .. " shipment " .. DarkRP.formatMoney( v.price ) )

			icon.Paint = function( s, w, h )
			
				draw.RoundedBox( 0, 0, 0, w, h, v.color or Color( 45, 45, 45 ) )

			end
			
			local oldpaint = icon.PaintOver
			icon.PaintOver = function( self, w, h )
			
				surface.SetDrawColor( category.color )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
			
				return oldpaint( self, w, h )
			
			end
			
			icon.DoClick = function( self )
			
				RunConsoleCommand( "darkrp", "buyshipment", v.name )
			
			end
			
			if icon:IsValid() then entlist:AddItem( icon ) end
			
		end

		for k, v in ipairs( members ) do

			AddIcon( v )
			
		end
		
	end
	
	parent:AddSheet( "Store", panel, "icon16/cart.png" )

end

function F4.Open()

	F4.Menu.Frame()
	
end

function F4.Close()

	if IsValid( F4.Frame ) then
		
		F4.Frame:SetVisible( false )
		
	end

end

function DarkRP.toggleF4Menu()
	
	if !IsValid( F4.Frame ) then
	
		F4.Open()
		
	elseif !F4.Frame:IsVisible() then 
	
		F4.Frame:SetVisible( true )
		
	else
	
		F4.Close()
		
	end
	
end

function DarkRP.getF4MenuPanel()

	return F4.Frame
	
end
