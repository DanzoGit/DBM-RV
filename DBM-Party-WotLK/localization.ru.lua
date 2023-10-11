﻿if GetLocale() ~= "ruRU" then return end
local L

local optionWarning		= "Предупреждение для %s"
local optionPreWarning	= "Предупреждать заранее о %s"

--------------------------------
--Ан'кахет: Старое Королевство--
--------------------------------

---------------------
--Старейшина Надокс--
---------------------
L = DBM:GetModLocalization(580)

------------------
--Принц Талдарам--
------------------
L = DBM:GetModLocalization(581)

------------------------------
--Джедога Искательница Теней--
------------------------------
L = DBM:GetModLocalization(582)

------------
--Аманитар--
------------
L = DBM:GetModLocalization(583)

------------------
--Глашатай Волаж--
------------------
L = DBM:GetModLocalization(584)

-------------
--Треш-мобы--
-------------
L = DBM:GetModLocalization("AKTrash")

L:SetGeneralLocalization({
	name = "Трэш Ан'кахет:СТ"
})

-----------
--Гундрак--
-----------

------------
--Слад'ран--
------------
L = DBM:GetModLocalization(592)

-------------------
--Колосс Драккари--
-------------------
L = DBM:GetModLocalization(593)

----------
--Мураби--
----------
L = DBM:GetModLocalization(594)

---------------
--Эк Свирепый--
---------------
L = DBM:GetModLocalization(595)

------------
--Гал'дара--
------------
L = DBM:GetModLocalization(596)

------------------
--Чертоги Молний--
------------------

---------------------
--Генерал Бьярнгрим--
---------------------
L = DBM:GetModLocalization(597)

----------
--Волхан--
----------
L = DBM:GetModLocalization(598)

---------
--Ионар--
---------
L = DBM:GetModLocalization(599)

---------
--Локен--
---------
L = DBM:GetModLocalization(600)

-------------
--Треш-мобы--
-------------
L = DBM:GetModLocalization("HoLTrash")

L:SetGeneralLocalization({
	name = "Трэш Чертогов Молний"
})

L:SetOptionLocalization({
	timerRoleplay = DBM_CORE_OPTION_TIMER_COMBAT
})

L:SetTimerLocalization({
	timerRoleplay = DBM_CORE_GENERIC_TIMER_COMBAT
})

L:SetMiscLocalization({
	RPLoken = "Я был свидетелем расцвета и падения империй... рождения и исчезновения целых рас... И только безрассудство смертных всегда оставалось неизменным. Ваше присутствие подтверждает это."
})

----------
--Нексус--
----------

--------------------------------------
--Командир Колург/Командир Пивобород--
--------------------------------------
L = DBM:GetModLocalization("Commander")

local commander = "Неизвестный"
if UnitFactionGroup("player") == "Alliance" then
	commander = "Командир Колург"
elseif UnitFactionGroup("player") == "Horde" then
	commander = "Командир Пивобород"
end

L:SetGeneralLocalization({
	name = commander
})

----------------------------
--Великая ведунья Телестра--
----------------------------
L = DBM:GetModLocalization(618)

L:SetMiscLocalization({
	SplitTrigger1		= "Меня на вас хватит!",
	SplitTrigger2		= "Вы получите больше, чем заслуживаете!"
})

------------
--Аномалус--
------------
L = DBM:GetModLocalization(619)

-----------------------------
--Орморок Воспитатель Дерев--
-----------------------------
L = DBM:GetModLocalization(620)

--------------
--Керистраза--
--------------
L = DBM:GetModLocalization(621)

-------------
--Треш-мобы--
-------------
L = DBM:GetModLocalization("TNTrash")

L:SetGeneralLocalization({
	name = "Трэш Нексуса"
})

------------------
--Вершина Утгард--
------------------

------------------------
--Свала Вечноскорбящая--
------------------------
L = DBM:GetModLocalization(641)

L:SetTimerLocalization({
	timerRoleplay		= "Свала Вечноскорбящая активируется"
})

L:SetOptionLocalization({
	timerRoleplay		= "Отсчет времени для представления перед активацией Свалы Вечноскорбящей"
})

L:SetMiscLocalization({
	SvalaRoleplayStart	= "Мой господин! Я сделала, как вы велели, и теперь молю вас о благословении!"
})

-------------------------
--Горток Бледное Копыто--
-------------------------
L = DBM:GetModLocalization(642)

----------------------
--Скади Безжалостный--
----------------------
L = DBM:GetModLocalization(643)

L:SetMiscLocalization({
	CombatStart		= "Что за недоноски осмелились вторгнуться сюда? Поживее, братья мои! Угощение тому, кто принесет мне их головы!",
	Phase2			= "Ничтожные лакеи! Ваши трупы послужат хорошей закуской для моего нового дракона!"
})

-----------------
--Король Имирон--
-----------------
L = DBM:GetModLocalization(644)

-------------
--Трэш-мобы--
-------------
L = DBM:GetModLocalization("UPTrash")

L:SetGeneralLocalization({
	name = "Трэш Вершина Утгард"
})

--------------
--Яма Сарона--
--------------

---------------------------
--Начальник кузни Гархлад--
---------------------------
L = DBM:GetModLocalization(608)

L:SetOptionLocalization({
	AchievementCheck	= "Объявлять предупреждения о достижении 'Не жди до одиннадцати!' в чат группы"
})

L:SetMiscLocalization({
	SaroniteRockThrow	= "%s швыряет в вас глыбой саронита!",
	AchievementWarning	= "Предупреждение: %s получил %d стаков Вечной мерзлоты",
	AchievementFailed	= ">> ДОСТИЖЕНИЕ ПРОВАЛЕНО: %s получил %d стаков Вечной мерзлоты <<"
})

-------------
--Ик и Крик--
-------------
L = DBM:GetModLocalization(609)

L:SetMiscLocalization({
	Barrage	= "%s начинает быстро создавать взрывающиеся снаряды."
})

----------------------------
--Повелитель Плети Тираний--
----------------------------
L = DBM:GetModLocalization(610)

L:SetMiscLocalization({
	CombatStart	= "Увы, бесстрашные герои, ваша навязчивость ускорила развязку. Вы слышите громыхание костей и скрежет стали за вашими спинами? Это предвестники скорой погибели.",
	HoarfrostTarget	= "Ледяной змей Иней смотрит на (%S+), готовя морозную атаку!",
	YellCombatEnd	= "Не может быть... Иней… Предупреди…"
})
