# AutoStory
Prototype plot generator, based on common sources

## Background

A long while ago, I discovered Georges Polti's [The Thirty-Six Dramatic Situations](https://en.wikipedia.org/wiki/The_Thirty-Six_Dramatic_Situations) and thought the (far lengthier than the title indicates) public domain list might make a good starting point for automated storytelling.  That is, each chapter/scene/section would be assigned a "dramatic situation" for the characters to resolve in that period.

Therefore, the premise was to take a common plot structure---here, an adaptation of the [Hero's Journey](https://en.wikipedia.org/wiki/Hero%27s_journey)---as an outline and plug in one of the Dramatic Situations for each element, suggesting a character in each role.

## The Data Files

There are three data files driving the randomized process.

### `chars.csv`

The characters---potential participants in the stories---each include a name, an optional role description (rarely used), a gender, and an abstract measure of "strength" to decide whether a character overcomes or falls to the selected dramatic challenge in cases where that seems meaningful.

Names and roles are stubs, chosen and expanded from the [Alice and Bob](https://en.wikipedia.org/wiki/Alice_and_Bob) placeholder names frequently used in cryptography discussions.

Character genders, incidentally, are currently limited to only `M` and `F`.  Should any expansion be needed, in the code, the `Character` class contains two hash tables defining them, `@@genders` for the pronoun to use for the character and `@@genderps` for the character's possessive pronouns.  Feel under-representative?  Please make a pull request!

### `steps.csv`

The steps of the story---the chapters or scenes or whatever, however you're writing---each include a name (for reporting), the likelihood that the step will be _skipped_ in a given story (0-9), the likelihood that the step will be _repeated_ in a given story (0-9), and a "level filter" which currently has the following options:

 - __`1`__:  The step should always appear as part of any story (unless randomly skipped)
 - __`2`__:  The step is a formally recognized part of the Hero's Journey
 - __`3`__:  The step appears in many stories and has been proposed by some as an optional part of the Hero's Journey

The filter (hopefully) makes it easier to scale the storytelling, from six basic candidate steps on up.


