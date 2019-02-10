# README

Project to try out some of the topics that people asked me during job interviews, such as Caching, Security, Testing.

## Note:

Since I never came up with a good API / Rails app idea, I could not test Cache and Security... so... this was kind of a useless exercise. Anyway, I could still try out Testing, Serialization and MongoDB.

### Note of the note:

**Active Model sucks**


## Environment setup

**Get your own public and private keys form de Marvel API, and set the as environment variables!** Call them _MARVEL_PRIVATE_KEY_ and _MARVEL_PUBLIC_KEY_.

Intall all the dependencies:

	brew install mongodb

	brew services start mongodb

	rvm gemset create i-dont-know-shit

	rvm gemset use i-dont-know-shit

	gem install activemodel, mongo, rubocop

Enter the mongo shell:
	
	use whatever_name_you_wanna_give_the_database

**Dont forget to set that name as an environment variable!**

Finally:

	ruby seeds.rb

## Running this shit

	require_relative 'models/battle'
	Battle.new.give_em_hell!

This will randomly choose two heroes from our Marvel database, but you can select two specific heroes to fight, passing a heroes list as a parameter to the _Battle_ constructor. This is shown below:

	require_relative 'models/battle'

    fighters_json = [
      {'id': 1009178,'name': 'Beef','str': 47,'hp': 157,'luck': 1}.to_json,
      {'id': 1009169,'name': 'Baron Strucker','str': 70,'hp': 62,'luck': 10}.to_json
    ]

    Battle.new(fighters_json).give_em_hell!

## Note: Solution development

All the code here was developed and tested using **Ruby 2.5.1**!

## Note: Battle

As I said ont the class comment, the fight logic isnt 100% correct, but you get the idea of it :smirk:
