# BoardGamesEmpire Database Model Documentation

This document provides an overview of the database models in the BoardGamesEmpire application, explaining the purpose of each model and clarifying complex relationships.

## Core Models

### User

Represents an application user with authentication information, profile details, and relationships to other entities.

- Serves as the central identity model for authentication and authorization
- Contains basic profile information and security settings
- Connected to households, games, collections, and social features

### Household

Represents a group of users who share games, play together, and track their gaming activities collectively.

- Functions as a family, friend group, or gaming club
- Provides a context for shared game collections and play sessions
- Maintains its own set of members, games, and events

### Game

Stores information about a board game, including metadata, relationships to designers, categories, etc.

- Core model containing standard game information
- Can be created from external APIs or as private user entries
- Contains relationships to various classification models (type, category, etc.)
- Can have customizations at user and household levels

### GameCollection

Represents a specific user's ownership of a game with personal metadata.

- Connects a User to a Game they own
- Tracks user-specific metadata about the game (rating, play count, etc.)
- Can be excluded from visibility to specific household members

## Game Classification Models

### GameType, Category, Mechanic, Family, Designer, Artist, Publisher

These models classify and describe games based on different aspects.

- **GameType**: Broad classification (board game, card game, etc.)
- **Category**: Game themes or topics (strategy, fantasy, etc.)
- **Mechanic**: Game mechanisms (worker placement, deck building, etc.)
- **Family**: Series or related game systems
- **Designer**: Game creators
- **Artist**: Visual contributors
- **Publisher**: Companies that publish games

Each of these has a junction model (e.g., GameCategory, GameDesigner) connecting it to specific games.

## Household-Related Models

### HouseholdMember

Represents a user's membership in a household with specific settings.

- Junction between User and Household
- Contains member-specific settings
- Controls which games from the user's collection are visible to the household

### HouseholdGame

Represents a game in the context of a specific household with household-specific metadata.

- Provides household-specific context for a game
- Tracks storage location, condition, and household-specific play statistics
- Contains social information about household-specific roles and dynamics
- Includes learning difficulty and teaching information for the household

### HouseholdGameExperience

Documents a memorable gameplay experience within a household.

- Records noteworthy gameplay moments
- Tracks specific participants through HouseholdGameExperienceParticipant
- Includes media and descriptive information about the experience

### HouseholdGameInterest

Tracks individual household members' interest in specific games.

- Records preference and desire to play
- Helps with game selection for events

## Game Customization Models

### UserGameCustomization

Stores user-specific customizations to game data without affecting the base game.

- Allows users to override official game information
- Only visible to the specific user

### HouseholdGameCustomization

Stores household-specific customizations to game data.

- Provides customized game information for a household
- Visible to all household members

## Game Play Models

### GamePlaySession

Records a specific instance of playing a game.

- Tracks when, where, and how a game was played
- Can be associated with an event or campaign
- Contains relationships to participants and results
- Can include expansions and rule variants used

### GamePlayParticipant

Represents a player in a game session.

- Can be a user or a guest
- Tracks performance and placement
- Can link to a campaign character if playing an RPG

### GamePlayResult

Stores detailed outcome information for a game session.

- Tracks scores, winners, and other result information
- Can handle complex scoring systems through JSON fields

## Event Models

### Event

Represents a social gathering for playing games.

- Can be a one-time or recurring event
- Has participants, suggested games, and related play sessions
- Includes location and timing information

### EventAttendee

Represents a participant in an event.

- Can be a registered user or a guest
- Tracks RSVP status and role
- Can suggest games and invite others

### EventGame

Tracks games suggested for an event.

- Links a game to an event with the person who suggested it
- Can collect votes through EventGameVote

## Campaign Models

### Campaign

Represents an ongoing roleplaying game campaign.

- Links to a game system
- Contains characters, locations, and NPCs
- Tracks campaign progress and sessions

### GameSystem

Defines a roleplaying game system.

- Contains system-specific attributes and options
- Used by campaigns for consistent rules

### CampaignCharacter

Represents a player character in a campaign.

- Links to a player and campaign
- Tracks character attributes and progression
- Records session participation

### CampaignLocation, CampaignNPC

Represent locations and non-player characters in a campaign.

- Help track campaign world building
- Record appearances in sessions

### CampaignSessionOutcome

Records the narrative outcomes of a campaign session.

- Tracks story developments and decisions
- Documents rewards and experience

## Rule Variant Models

### RuleVariant

Represents a custom or house rule.

- Can apply to games, campaigns, or households
- Contains detailed rule text and examples
- Can track when and how it was used
- Supports versioning for rule evolution

### RuleVariantUsage

Tracks when a rule variant was used in a specific session.

- Links rule variants to game sessions
- Records feedback on rule effectiveness
- Can track which expansions and versions were used with the rule

## Relationship Junction Models

Many models serve as explicit junction tables to connect many-to-many relationships:

### ExcludedGame

- Connects HouseholdMember to GameCollection
- Tracks which games a member doesn't want to see in household

### GameHouseholdAccess, GameUserAccess

- Control access to private games
- Track who can see, edit, and share private games

### HouseholdGameExperienceParticipant

- Connects participants to game experiences
- Tracks member-specific details about the experience

### ExpansionCompatibility

- Links games to compatible expansions
- Includes metadata about compatibility

## Permission Models

### Role, Permission

Define what actions users can perform.

- Roles group permissions for easier assignment
- Permissions define specific actions

### UserRole, HouseholdRole

Assign roles to users globally or within households.

- UserRole assigns system-wide roles
- HouseholdRole assigns roles within a specific household context

### UserPermission, GroupPermission

Define direct permissions or permission groups.

- UserPermission grants specific permissions to users
- GroupPermission defines groups of permissions

### CampaignMemberPermission, EventMemberPermission

Control permissions in specific contexts.

- Grant permissions for campaigns and events
- Allow fine-grained access control
