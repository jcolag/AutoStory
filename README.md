# AutoStory
Prototype plot generator, based on common sources

## Background

A long while ago, I discovered Georges Polti's [The Thirty-Six Dramatic Situations](https://en.wikipedia.org/wiki/The_Thirty-Six_Dramatic_Situations) and thought the (far lengthier than the title indicates) public domain list might make a good starting point for automated storytelling.  That is, each chapter/scene/section would be assigned a "dramatic situation" for the characters to resolve in that period.

Therefore, the premise was to take a common plot structure---here, an adaptation of the [Hero's Journey](https://en.wikipedia.org/wiki/Hero%27s_journey)---as an outline and plug in one of the Dramatic Situations for each element, suggesting a character in each role.

## The Files

There are three data files driving the randomized process.

### `chars.csv`

The characters---potential participants in the stories---each include a name, an optional role description (rarely used), a gender, and an abstract measure of "strength" to decide whether a character overcomes or falls to the selected dramatic challenge in cases where that seems meaningful.

Names and roles are stubs, chosen and expanded from the [Alice and Bob](https://en.wikipedia.org/wiki/Alice_and_Bob) placeholder names frequently used in cryptography discussions.

Character genders, incidentally, are currently limited to only `M` and `F`.  Should any expansion be needed, in the code, the `Character` class contains two hash tables defining them, `@@genders` for the pronoun to use for the character and `@@genderps` for the character's possessive pronouns.  Feel under-representative?  Please make a pull request!


