# Finisher-Score-Cricket

## Project Description:

There has always been a dispute of who the best finisher is though the name that comes first to everyone's mind is MS Dhoni. I started
this project back in 2015 with the intention of answering the question "Is MS Dhoni really a finisher?" through a data backed approach
which in some way is undisputable. I came up with a "Universal Finisher Criterion" which resulted in a score for MS Dhoni but the same 
had to be compared with another player to substantiate Dhoni's score. The player was Michael Bevan, another acclaimed finisher of his 
times,and he ranked below Dhoni

Restarting this project, I felt the need to apply the universal finsiher criterion across all the players who have ever played One Day
international (ODI) cricket and the best database that I could turn to was [espncricinfo.com] (http://www.espncricinfo.com/). The project was done on both python and R. Scrapping was done in Python and cleaning the data (a lot!) along with arriving at the score was done through R

## Universal finisher criterion*:

It is the ratio of the number of matches that the player satisfied the finsiher criteria **(Runs>=30,Margin<=6,BR=30,Not-out,Result=won,
Batting=2nd)** to the number of matches the team won chasing

*Subject to changes and feedback

## Data:

There were two datasets scrapped from [espncricinfo.com](http://www.espncricinfo.com/) one being the **player batting data** and another
the **match result data**. The same was done by identifying player's ID. Unique identifier between these two data sets was the 
combination of palyer name/player ID and ODI.number. The varaibles in the two data sets are explained below (may not be required for a 
cricket follower):

### Match result data set:

Player.ID = ID assigned by cricinfo which was used for scrapping,
Player.Name = Name of the player ex. Sachin Tendulkar,
BR = Balls remaining,
Bat = first or second innings in a ODI,
Ground = the ground in which the corresponding ODI was played,
Margin = margin by which the team won..by chasing it would be in wickets defending it would be runs,
ODI.number = counting the number of ODIs,
Start.date = the date on which the match was played,
opposition = Opposition country,
Result = most importantly did the team win or not,
Toss = toss lost or won

### Player data set:

Player.ID = ID assigned by cricinfo which was used for scrapping,
Player.Name = Name of the player ex. Sachin Tendulkar,
4s = No of fours,
6s = No. of sixes,
BF = no. of balls faced,
Dismissal = mode of dismissal i..e, caught, bowled,
Ground = similar to the above,
Inns = similar to "Inns" above,
Mins = time spent on the field by the player,
ODI.number = counting the number of ODIs,
Start.date = the date on which the match was played,
opposition = Opposition country,
runs = total runs scored with * denoting not-out,
score = Runs scored,
SR = strike rate,
POS = batting poisition

The second data set may look redunant and repititve. Yes! it is and the only mandatory variable required are Player.ID/Player.Name,runs,
ODI.number. POS though not used is one important variable

## Code:

A modular code was written (u can find the same in the folder "Codes"). It is sufficiently commented helping the viewer to understand
each piece of the code and also finally pastes the scores for each of the player.

## Result:

The top 5 are tabulated below:

| MS Dhoni	   |    28.57     |
| AD Mathews   |    20.69     |
| MG Bevan	   |    20.00     |
| MEK Hussey   |	  18.52     |
| L Klusener   |	  18.18     |

The fact that only middle/lower middle order players will appear in the list should be accepted since the problem statement and criterion are aligned towards the same. However, a dispute may arise questioning the consistency of the finisher and for the same
I have done some visualization as below

<p align="center">
  <img src="https://github.com/Rahulpodi/Finisher-Score---Cricket/blob/master/Results/Consistency.png" width="650"/>
</p>

P.S: The above graph is a stacked plot

