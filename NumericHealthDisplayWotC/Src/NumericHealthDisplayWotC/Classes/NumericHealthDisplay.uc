// This is an Unreal Script
Class NumericHealthDisplay extends UIUnitFlag
	config(NumericHealthDisplay);

var UIText hpText, hpShadow, maxHPText, maxHPShadow, shieldText, shieldShadow, armorText, armorShadow;
var UIIcon hpIcon, shieldIcon, armorIcon;
var UIBGBox hpBG, hpBGDark, shieldBG, armorBG, willBar, willBG, focusBar, focusBG;
var config int IconSize;
var config int BarHeight;
var config int WillBarHeight;
var config int FocusBarHeight;
var config int MaxHPTextSize;
var config int TextPrePadding;
var config int EndPadding;
var config int BGAlpha;
var config int FirstIconX;
var config int IconY;
var config int IconSpacing;
var config int FocusBarBite;
var config bool FixedWidth;
var config int FixedWidthSize;
var config int SecondaryBarWidth;
var config string FriendlyHealthBarColor;
var config string FriendlyBarBGColor;
var config string EnemyHealthBarColor;
var config string EnemyBarBGColor;
var config string ChosenHealthBarColor;
var config string ChosenBarBGColor;
var config string ArmorBGColor;
var config string ShieldBGColor;
var config string FriendlyHealthForegroundColor;
var config string WillBarColor;
var config string WillBarBGColor;
var config string FocusBarColor;
var config string FocusBarBGColor;
var config string EnemyHealthForegroundColor;
var config string ShieldForegroundColor;
var config string ArmorForegroundColor;
var config bool DisplayStandardHealthBar;
var config bool InLineHPBar;

// put all this setup stuff in its own function
simulated function HPSetup()
{
	// Hide standard hp bar
	if(!DisplayStandardHealthBar)
	{
		Movie.SetVariableBool(MCPath $ ".healthMeter._visible", false);
	}
	// First created UI elements are drawn at the bottom
	hpBGDark = Spawn(class 'UIBGBox', self).InitBG();
	hpBG = Spawn(class 'UIBGBox', self).InitBG();
	FriendFoeColor();
	hpBGDark.SetHeight(BarHeight);
	hpBGDark.SetX(FirstIconX);
	hpBGDark.SetY(IconY);
	hpBGDark.SetAlpha(BGAlpha);
	if(!InLineHPBar)
	{
		hpBGDark.Hide();
	}
	hpBG.SetHeight(BarHeight);
	hpBG.SetX(FirstIconX);
	hpBG.SetY(IconY);
	hpBG.SetAlpha(BGAlpha);
	///
	shieldBG = Spawn(class 'UIBGBox', self).InitBG();
	shieldBG.SetColor(ShieldBGColor);
	shieldBG.SetHeight(BarHeight);
	shieldBG.SetY(IconY);
	shieldBG.SetAlpha(BGAlpha);
	///
	armorBG = Spawn(class 'UIBGBox', self).InitBG();
	armorBG.SetColor(ArmorBGColor);
	armorBG.SetHeight(BarHeight);
	armorBG.SetY(IconY);
	armorBG.SetAlpha(BGAlpha);
	///
	willBG = Spawn(class 'UIBGBox', self).InitBG();
	willBar = Spawn(class 'UIBGBox', self).InitBG();
	WillBG.SetX(FirstIconX);
	WillBar.SetX(FirstIconX);
	willBG.SetY(IconY + BarHeight);
	willBar.SetY(IconY + BarHeight);
	willBG.SetColor(WillBarBGColor);
	WillBar.SetColor(WillBarColor);
	WillBG.SetWidth(FixedWidthSize);
	//Setting width of will bar fill elsewhere
	WillBG.SetHeight(WillBarHeight);
	WillBar.SetHeight(WillBarHeight);
	WillBG.SetAlpha(BGAlpha);
	WillBar.SetAlpha(BGAlpha);
	///
	focusBG = Spawn(class 'UIBGBox', self).InitBG();
	focusBar = Spawn(class 'UIBGBox', self).InitBG();
	focusBG.SetX(FirstIconX + FocusBarBite);
	focusBar.SetX(FirstIconX + FocusBarBite);
	focusBG.SetY(IconY + BarHeight);
	focusBar.SetY(IconY + BarHeight);
	focusBG.SetColor(focusBarBGColor);
	focusBar.SetColor(focusBarColor);
	focusBG.SetWidth(SecondaryBarWidth - FocusBarBite);
	//Setting width of focus bar fill elsewhere
	focusBG.SetHeight(focusBarHeight);
	focusBar.SetHeight(focusBarHeight);
	focusBG.SetAlpha(BGAlpha);
	focusBar.SetAlpha(BGAlpha);
	///
	hpIcon = Spawn(class 'UIIcon', self).InitIcon();
	shieldIcon = Spawn(class 'UIIcon', self).InitIcon();
	armorIcon = Spawn(class 'UIIcon', self).InitIcon();
	hpIcon.LoadIcon("img:///HealthDisplay.Health");
	shieldIcon.LoadIcon("img:///HealthDisplay.Shield");
	armorIcon.LoadIcon("img:///HealthDisplay.Armor");
	hpIcon.SetSize(IconSize, IconSize);
	shieldIcon.SetSize(IconSize, IconSize);
	armorIcon.SetSize(IconSize, IconSize);
	hpIcon.SetY(IconY);
	shieldIcon.SetY(IconY);
	armorIcon.SetY(IconY);
	hpIcon.HideBG();
	if(m_bIsFriendly.GetValue())
	{
		hpIcon.SetForegroundColor(FriendlyHealthForegroundColor);
	}
	else
	{
		hpIcon.SetForegroundColor(EnemyHealthForegroundColor);
	}
		
	shieldIcon.HideBG();
	shieldIcon.SetForegroundColor(ShieldForegroundColor);
	armorIcon.HideBG();
	armorIcon.SetForegroundColor(ArmorForegroundColor);
	// HP
	hpText = Spawn(class'UIText', self).InitText();
	hpText.SetY(IconY - 4);
	if(m_bIsFriendly.GetValue())
	{
		hpText.SetColor(FriendlyHealthForegroundColor);
	}
	else
	{
		hpText.SetColor(EnemyHealthForegroundColor);
	}
		
	// Shield
	shieldText = Spawn(class'UIText', self).InitText();
	shieldText.SetY(IconY - 4);
	shieldText.SetColor(ShieldForegroundColor);
	// Armor
	armorText = Spawn(class'UIText', self).InitText();
	armorText.SetY(IconY - 4);
	armorText.SetColor(ArmorForegroundColor);
}

simulated function FriendFoeColor()
{
	if(m_bIsFriendly.GetValue())
	{
		hpBGDark.SetColor(FriendlyBarBGColor);
		hpBG.SetColor(FriendlyHealthBarColor);
	}
	else if (m_bIsChosen)
	{
		hpBGDark.SetColor(ChosenBarBGColor);
		hpBG.SetColor(ChosenHealthBarColor);
	}
	else
	{
		hpBGDark.SetColor(EnemyBarBGColor);
		hpBG.SetColor(EnemyHealthBarColor);
	}
}

simulated function RealizeHitPoints(optional XComGameState_Unit NewUnitState = none) 
{
	local ASValue myValue;
	local Array<ASValue> myArray;
	local int armorActive, currentHP, maxHP, currentArmor, currentShields, minHPLength;
	// copied from UIUnitFlag
	local XComGameState_Effect_TemplarFocus FocusState;
	local XComGameState_Unit PreviousUnitState;
	local int previousWill;
	local int currentWill;
	local int maxWill;
	local int currentFocus;
	local int maxFocus;
	local int focusBarWidth;
	local int willBarWidth;
	//
	armorActive = 0;

	// Get the HP numbers for all types.
	if( NewUnitState == none )
	{
		NewUnitState = XComGameState_Unit(History.GetGameStateForObjectID(StoredObjectID));
	}
	// Set will variables
	PreviousUnitState = XComGameState_Unit(NewUnitState.GetPreviousVersion());
	CurrentWill = NewUnitState.GetCurrentStat(eStat_Will);
	MaxWill = NewUnitState.GetMaxStat(eStat_Will);
	if (PreviousUnitState != none)
	{
		PreviousWill = PreviousUnitState.GetCurrentStat(eStat_Will);
	}
	currentHP = NewUnitState.GetCurrentStat(eStat_HP);
	maxHP = NewUnitState.GetMaxStat(eStat_HP);
	currentArmor = NewUnitState.GetArmorMitigationForUnitFlag();
	currentShields = NewUnitState.GetCurrentStat(eStat_ShieldHP);
	// Telling the standard UI that health is 0 hides the healthbar.
	// Or at least it used to. Now it leaves behind an ugly grey bar :(
	if(DisplayStandardHealthBar)
	{
		Super.SetHitPoints( NewUnitState.GetCurrentStat(eStat_HP), NewUnitState.GetMaxStat(eStat_HP) );
		Super.SetShieldPoints( NewUnitState.GetCurrentStat(eStat_ShieldHP), NewUnitState.GetMaxStat(eStat_ShieldHP) );
		Super.SetArmorPoints( NewUnitState.GetArmorMitigationForUnitFlag() );
	}
	else
	{
		myValue.Type = AS_Number;
		myValue.n = 0;
		myArray.AddItem( myValue );
		myValue.n = 0;
		myArray.AddItem( myValue );
		//Invoke("SetHitPoints", myArray);
	}
	// expansion stuff
	//Super.SetWillPoints(NewUnitState.GetCurrentStat(eStat_Will), NewUnitState.GetMaxStat(eStat_Will), PreviousWill);

	FocusState = NewUnitState.GetTemplarFocusEffectState();
	//if( FocusState != none )
	//{
		//Super.SetFocusPoints(FocusState.FocusLevel, FocusState.GetMaxFocus(NewUnitState));
	//}
	Super.RealizeMeterPosition();

	// Remove unitflag from dead units.
	if ( currentHP < 1 )
	{
		m_bIsDead = true;
		Remove();
	}
	// Initialize text and icons if they haven't already.
	if(hptext == none)
	{
		HPSetup();
	}
	FriendFoeColor();
	// custom
	if( m_bIsFriendly.GetValue() || `XPROFILESETTINGS.Data.m_bShowEnemyHealth ) // Show health if friendly or enemy health display is enabled (which it is by default).
	{
		// HP. Everything has HP.
		minHPLength = IconSize + Len(currentHP $ "/" $ maxHP) * IconSize * 0.5 + EndPadding; 
		if(FixedWidth)
		{
			hpBG.SetWidth(Max(FixedWidthSize, minHPLength));
		}
		else
		{
			hpBG.SetWidth(minHPLength);
		}
		hpText.SetHtmlText("<font size='" $ IconSize $ "' face='$TitleFont'>" $ currentHP $ "</font><font size='" $ MaxHPTextSize $ "' face='$TitleFont' >/" $ maxHP $ "</font>");
		hpText.SetX(FirstIconX + IconSize + TextPrePadding);
		hpIcon.SetX(FirstIconX);
		// Armor
		if(currentArmor > 0)
		{
			armorBG.SetWidth(IconSize + Len(string(currentArmor)) * 16 + EndPadding);
			if(FixedWidth)
			{
				hpBG.SetWidth(Max(minHPLength, hpBG.Width - armorBG.Width));
			}
			armorBG.SetX(FirstIconX + hpBG.Width + IconSpacing);
			armorText.SetHtmlText("<font size='" $ IconSize $ "' face='$TitleFont'>" $ currentArmor $ "</font>");
			armorText.SetX(armorBG.X + IconSize + TextPrePadding);
			armorIcon.SetX(armorBG.X);

			armorBG.Show();
			armorText.Show();
			armorIcon.Show();

			armorActive = 1;
		}
		else
		{
			armorBG.Hide();
			armorText.Hide();
			armorIcon.Hide();
			armorActive = 0;
		}
		// Shields
		if(currentShields > 0)
		{
			shieldBG.SetWidth(IconSize + Len(string(currentShields)) * 16 + EndPadding);
			if(FixedWidth)
			{
				hpBG.SetWidth(Max(minHPLength, hpBG.Width - shieldBG.Width));
				armorBG.SetX(FirstIconX + hpBG.Width + IconSpacing);
				armorText.SetX(armorBG.X + IconSize + TextPrePadding);
				armorIcon.SetX(armorBG.X);
			}
			shieldBG.SetX(FirstIconX + hpBG.Width + (armorBG.Width + IconSpacing) * armorActive + IconSpacing);

			shieldText.SetHtmlText("<font size='" $ IconSize $ "' face='$TitleFont'>" $ currentShields $ "</font>");
			shieldText.SetX(shieldBG.X + IconSize + TextPrePadding);
			shieldIcon.SetX(shieldBG.X);

			shieldBG.Show();
			shieldText.Show();
			shieldIcon.Show();
		}
		else
		{
			shieldBG.Hide();
			shieldText.Hide();
			shieldIcon.Hide();
		}
		// Will
		if(m_bIsFriendly.GetValue() && m_bUsesWillSystem) // Only show will on friendly units
		{
			WillBG.Show();
			WillBar.Show();
			if(currentWill == 0)
			{
				willBarWidth = 1;
			}
			else
			{
				willBarWidth = float(currentWill) / float(maxWill) * SecondaryBarWidth;
			}
			WillBar.SetWidth(willBarWidth);
		}
		else
		{
			WillBG.Hide();
			WillBar.Hide();
		}
		// Focus
		if(FocusState != none)
		{
			FocusBG.Show();
			FocusBar.Show();
			currentFocus = FocusState.FocusLevel;
			maxFocus = FocusState.GetMaxFocus(NewUnitState);
			if(currentFocus == 0)
			{
				focusBarWidth = 1;
			}
			else
			{
				focusBarWidth = float(currentFocus) / float(maxFocus) * (SecondaryBarWidth - FocusBarBite);
			}
			FocusBar.SetWidth(focusBarWidth);
			FocusBG.SetY(Willbar.Y);
			FocusBar.SetY(Willbar.Y);
			if(m_bIsFriendly.GetValue() && m_bUsesWillSystem)
			{
				FocusBG.SetY(Willbar.Y + WillBarHeight);
				FocusBar.SetY(Willbar.Y + WillBarHeight);
			}
		}
		else
		{
			FocusBG.Hide();
			FocusBar.Hide();
		}
		// bleh
		if(InLineHPBar)
		{
			hpBGDark.SetWidth(hpBG.Width);
			hpBG.SetWidth(hpBG.Width * currentHP / maxHP);
		}
	}	
}