# Rockman & Forte (SFC) Practice Hack
This is an IPS patch for Rockman & Forte for speedrun practice. 

### Features 
- Stage select is always open, and assigns the speedrun weapons/items/equipment upon load. Stage select has greyed out bosses, but upon loading they will be properly spawned. Only Rockman's placements available for now.

- While in any stage:
  - Select + B + Y = Return instantly to stage select
  - Select + B + X = Restore all HP and Weapon Energy
  - Select + L + R = Change RNG value (increase by 0x0001 each frame)

- While on stage select:
  - Hold L upon King Stage select: Go to King Stage 2
  - Hold R upon King Stage select: Go to King Stage 3

- CDs are automatically reset upon stage load.   
  
### Applying a patch
Within the `patches` directory, download the latest `.ips` file and use [Lunar IPS](https://fusoya.eludevisibility.org/lips/) to apply to a .sfc file. 

### Credits
[@cleartonic](https://twitter.com/cleartonic)
