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

### `sit.csv`

This is the big deal, the core data that turns _AutoStory_ into something more worthwhile than just a description of the Hero's Journey.  The Dramatic Situations (adapted from Polti's book) each include a descriptive template, a challenge description, and a situation code referring to Polti's text.

The situations are a work in progress.  Despite the title of the book, there are _hundreds_ of dramatic situations listed, and they're each described (of course) in prose.  Many are also described in a "classic form" that assumes romantic or military relationships.  So, much of the work involved in specifying the situations involves bowlderizing/generalizing the situations to embrace a world where Platonic relationships and not murdering people are routine.

#### Templates

The template strings turns Polti's phrases like "Fugitives imploring the powerful for help against their enemies" (1-A1) into variations based on the relationships between character archetypes (for example, __Protagonist__, __Antagonist__, __Sidekick__) and naming those archetypes in square-brackets, in addition to providing alternative interpretations in squiggly-braces.  So, we might end up with "`[Sidekick] is a fugitive asking [Antagonist] for {sanctuary from,help against} a common enemy confused with [Protagonist].`"

#### Challenge

The challenge string names one or two character archetypes listed in the _template_ described above (separated by a slash---"`/`"---if two) followed by a challenge level (separated from the archetype by an underscore character---"`_`").  _AutoStory_ uses that information, combined with the _strength_ of the character described in its entry, to determine whether the active character should ultimately succeed in the challenge and to what degree.

A typical challenge description might look like `Antagonist_7` (the character acting as the antagonist performs a difficult action with no opposition from other characters) or `Sidekick_6/Protagonist_3`, describing a situation where the characters acting as the sidekick and protagonist are at odds, and the sidekick has the greater obstacle to overcome.

# Example Output

Even with the situations only partially encoded, we can still get a sense of _AutoStory_'s results with a sample run:

> [34A1] Quentin tries to overcome remorse for a feeling of having done something horrible.
> Call to Adventure:  [1A4] Charlie appeals to Quentin for needed information.  Charlie resists Quentin, easily.
> Refusal of the Call:  [9D2] Quentin undertakes an adventure to seize the plot device to undermine Charlie.
> Crossing the First Threshold:  [3B2] Quentin pursues Charlie for some insult during Quentin's absence.
> Commitment:  [1C1] Quentin asks Victor to leave Charlie to his or her own fate.  Quentin resists Victor, easily.
> Road of Trials:  [19D] Quentin harms Victor without realizing the extent of Victor's help.
> Road of Trials:  [9D4] Quentin undertakes an adventure to force the plot device on Charlie to undermine Charlie.
> Road of Trials:  [14A1] Charlie takes out his frustration at a lack of status on Quentin.
> Road of Trials:  [3B3] Quentin pursues Charlie for some attempted insult to harm Quentin.
> Temptation:  [19A3] Quentin considers abandoning Victor due to Victor's unpleasant associations.
> Achievement:  [1A3] Quentin asks Charlie for a respite.  Quentin resists Charlie.
> Escape:  [22A1] Quentin violates a principle in a moment of desperation.
> Crossing of the Return Threshold:  [13A4] Quentin and Victor endanger their relationship due to conflicting interests.
> Living in the Moment:  [20A4] Quentin sacrifices the plot device to Charlie for the sake of principle.

From this, it's surprisingly easy to see the story take shape by combining the dramatic situation with the stage of the story.  So, the overall plot is Quentin's attempt to make amends and we can see how Charlie's question might trigger that, and how Quentin's plan to undermine his (presumably) friend is an attempt to reject what he needs to do, until Victor (who may carry additional meaning as "the Verifier," remember) gets involved, pushing Quentin on his way through many frustrating turns until he weighs walking away from the whole situation.  He fights Victor to return to normalcy and eventually (this appropriate a selection is a coincidence) seems to outright make amends with Charlie.

Obviously, the challenge-resolution code needs some work, since active parties shouldn't be winning by "resisting," but the rest is often surprisingly readable.

