extensions [matrix]

;breeds
breed [ students student ]
breed [ teachers teacher ]
breed [ principals principal ]
breed [ janitors janitor ]



;variables
globals [
  seed seedRun
  movement-time-in-seconds
  movements-per-tick

  num-students num-teachers num-school-janitors
  num-agents
  num-susceptible num-exposed num-infected num-removed
  num-susceptible-in-quarantine num-exposed-in-quarantine
  num-infected-in-quarantine num-removed-in-quarantine
  num-susceptible-in-quarantine-external-1 num-exposed-in-quarantine-external-1
  num-infected-in-quarantine-external-1 num-removed-in-quarantine-external-1
  num-susceptible-in-quarantine-external-2 num-exposed-in-quarantine-external-2
  num-infected-in-quarantine-external-2 num-removed-in-quarantine-external-2
  num-infected-outside
  num-vaccinated-susceptible num-vaccinated-exposed num-vaccinated-infected num-vaccinated-removed
  num-vaccinated-susceptible-in-quarantine num-vaccinated-exposed-in-quarantine
  num-vaccinated-infected-in-quarantine num-vaccinated-removed-in-quarantine
  num-vaccinated-susceptible-in-quarantine-external-1 num-vaccinated-exposed-in-quarantine-external-1
  num-vaccinated-infected-in-quarantine-external-1 num-vaccinated-removed-in-quarantine-external-1
  num-vaccinated-susceptible-in-quarantine-external-2 num-vaccinated-exposed-in-quarantine-external-2
  num-vaccinated-infected-in-quarantine-external-2 num-vaccinated-removed-in-quarantine-external-2

  classroom-letters age-groups rooms-aerosol classroom-name

  contact-time-with-infected-matrix-in-ticks is-in-contact-matrix? contact-time-matrix-in-ticks number-of-contact-matrix
  contamination-risk contamination-risk-decreased-with-mask

  exhalation-mask-efficiency inhalation-mask-efficiency

  infectious-vaccinated-factor

  starting-floors-x starting-floors-y

  classroom-dimension-x classroom-dimension-y
  corridor-dimension-x corridor-dimension-y
  bathroom-dimension-x bathroom-dimension-y
  hall-dimension-x hall-dimension-y
  road-dimension-x
  principal-office-dimension-x principal-office-dimension-y
  teachers-room-dimension-x teachers-room-dimension-y
  gym-dimension-x gym-dimension-y
  measurement-room-dimension-x measurement-room-dimension-y

  one-patch-in-meters

  classroom-length-in-meters classroom-width-in-meters
  gym-length-in-meters gym-width-in-meters
  principal-office-length-in-meters principal-office-width-in-meters
  teachers-room-length-in-meters teachers-room-width-in-meters
  contact-space-length-in-meters contact-space-width-in-meters
  measurement-room-length-in-meters measurement-room-width-in-meters
  bathroom-length-in-meters bathroom-width-in-meters
  room-height gym-height
  classroom-area gym-area principal-office-area teachers-room-area
  contact-space-area measurement-room-area bathroom-area
  classroom-volume gym-volume principal-office-volume teachers-room-volume
  contact-space-volume measurement-room-volume bathroom-volume

  inhalation-rate-pure vl ngen-base risk-const
  activity-type-students activity-type-students-in-gym
  activity-type-teachers-in-classroom activity-type-teachers
  activity-type-principals activity-type-janitors

  ventilation decay-rate-of-the-virus gravitational-settling-rate
  total-first-order-loss-rate

  inhalation-rate-students inhalation-rate-students-in-gym
  inhalation-rate-teachers inhalation-rate-teachers-in-classroom
  inhalation-rate-principals inhalation-rate-janitors

  num-active-agents
  mean-quanta-inhaled
  mean-quanta-inhaled-in-classroom
  mean-quanta-inhaled-in-gym
  mean-quanta-inhaled-in-measurement-room
  mean-quanta-inhaled-in-principal-office
  mean-quanta-inhaled-in-teachers-room
  mean-quanta-inhaled-in-bathroom

  classrooms-scheduling effective-classrooms-scheduling
  effective-teachers-flat
  gym-teachers
  supply-teachers supply-janitors

  staggered-time-in-ticks

  last-principal-time-in-ticks

  start-day-time-in-ticks offset-between-days-in-ticks
  lesson-duration-in-ticks interval-duration-in-ticks
  offset-between-entrance-and-start-lessons-in-ticks
  start-lessons-time-in-ticks finish-lessons-time-in-ticks
  start-intervals-time-in-ticks
  remain-time-for-lesson-in-ticks remain-time-for-interval-in-ticks

  finish-lessons-time-in-ticks-backup

  temperature-measurement-mean-time-in-seconds temperature-measurement-std-in-seconds
  patches-queue1 patches-queue2
  num-in-queue1 num-in-queue2

  next-group-activate screening-groups sub-screening-groups next-screening-group next-sub-screening-group
  num-of-screening-group num-of-sub-screening-group

  num-of-screened-students
  num-of-screened-students-external-1
  num-of-screened-students-external-2
  num-of-positive-students
  num-of-positive-students-external-1
  num-of-positive-students-external-2
  classrooms-in-quarantine

  after-days-swab-classrooms after-days-counters

  days-of-week

  end-day?

  day school-day
  starting-hour starting-minute starting-second
  hour minute second
  weekend?

  print-day?
]

turtles-own [
  susceptible? exposed? infected? removed?
  quarantined? vaccinated? screening-adhesion?
  quarantined-external-1? quarantined-external-2?

  desk classroom floor-idx toilet

  move-time-in-ticks

  age-group staggered-group screening-group sub-screening-group

  queue queue-position temperature-time-in-ticks temperature-already-measured?

  toilet-time-in-ticks

  remain-incubation-days remain-infected-days remain-quarantine-days

  cumulative-quanta-inhaled
  cumulative-quanta-inhaled-in-classroom
  cumulative-quanta-inhaled-in-gym
  cumulative-quanta-inhaled-in-measurement-room
  cumulative-quanta-inhaled-in-principal-office
  cumulative-quanta-inhaled-in-teachers-room
  cumulative-quanta-inhaled-in-bathroom

  dad?

  gym-hour?

  targets
]

students-own [
  blackboard-time-in-ticks principal-time-in-ticks
]

teachers-own [
  teacher-idx
  gym-teacher?
  supply?

  personal-classrooms-scheduling day-scheduling first-day-of-work

  update?
]

janitors-own [
  supply?
]

patches-own [
  classroom? corridor? bathroom? outdoor? principal-office? gym? teachers-room? measurement-room?

  desk?
  chair? teacher-chair? principal-chair?
  blackboard?
  entrance? exit?
  toilet? occupied?
  stair?

  measure-temperature-patch?

  room-name floor-number
  in-front-of

  group-patch

  cumulative-quanta-concentration
]



;setup phase
to setup
  clear-all
  reset-ticks

  setup-seed

  read-file-classrooms-scheduling-and-gym-teachers

  setup-global-variables
  setup-patches-variables
  setup-world
  setup-agents
end

to setup-seed
  file-open "Utils/Seed.txt"

  if not file-at-end?
    [ set seed file-read ]

  file-close

  set seedRun seed + run#

  random-seed seedRun
end

to setup-global-variables
  setup-general-variables
  setup-counters-variables
  setup-graphical-variables
  setup-temperature-measurement-variables
  setup-time-variables
  setup-screening-variables
  setup-contagion-variables
end

to setup-general-variables
  set movement-time-in-seconds 4
  set movements-per-tick tick-duration-in-seconds / movement-time-in-seconds

  if not staggered-admissions? or
     num-classrooms-per-floor * num-floors = 1
    [ set num-groups 1 ]

  set classroom-letters (list "A" "B" "C" "D")
  set age-groups (list "Young" "Regular" "Old")
  set rooms-aerosol (list "G" "TR" "PO" "TT")
  set classroom-name []

  set days-of-week (list "monday" "tuesday" "wednesday" "thursday" "friday")

  set end-day? n-values num-groups [true]

  set weekend? false
  set print-day? false
end

to setup-counters-variables
  set num-students students-per-classroom * num-classrooms-per-floor * num-floors
  set num-exposed 0
  set num-infected 0
  set num-removed 0
  set num-susceptible-in-quarantine 0
  set num-exposed-in-quarantine 0
  set num-infected-in-quarantine 0
  set num-removed-in-quarantine 0
  set num-susceptible-in-quarantine-external-1 0
  set num-exposed-in-quarantine-external-1 0
  set num-infected-in-quarantine-external-1 0
  set num-removed-in-quarantine-external-1 0
  set num-susceptible-in-quarantine-external-2 0
  set num-exposed-in-quarantine-external-2 0
  set num-infected-in-quarantine-external-2 0
  set num-removed-in-quarantine-external-2 0
  set num-infected-outside 0
  set num-vaccinated-susceptible 0
  set num-vaccinated-exposed 0
  set num-vaccinated-infected 0
  set num-vaccinated-removed 0
  set num-vaccinated-susceptible-in-quarantine 0
  set num-vaccinated-exposed-in-quarantine 0
  set num-vaccinated-infected-in-quarantine 0
  set num-vaccinated-removed-in-quarantine 0
  set num-vaccinated-susceptible-in-quarantine-external-1 0
  set num-vaccinated-exposed-in-quarantine-external-1 0
  set num-vaccinated-infected-in-quarantine-external-1 0
  set num-vaccinated-removed-in-quarantine-external-1 0
  set num-vaccinated-susceptible-in-quarantine-external-2 0
  set num-vaccinated-exposed-in-quarantine-external-2 0
  set num-vaccinated-infected-in-quarantine-external-2 0
  set num-vaccinated-removed-in-quarantine-external-2 0

  set next-screening-group 0
  set next-sub-screening-group 0
  set num-of-screening-group 0
  set num-of-sub-screening-group 0

  set num-of-screened-students 0
  set num-of-screened-students-external-1 0
  set num-of-screened-students-external-2 0
  set num-of-positive-students 0
  set num-of-positive-students-external-1 0
  set num-of-positive-students-external-2 0

  set num-in-queue1 0
  set num-in-queue2 0

  set starting-hour 7
  set starting-minute 35
  set starting-second 0

  set day 0
  set school-day 0
end

to setup-graphical-variables
  set starting-floors-x 2
  set starting-floors-y 2

  set classroom-dimension-x 10
  set classroom-dimension-y 10
  set corridor-dimension-x classroom-dimension-x + 1
  set corridor-dimension-y 8
  set bathroom-dimension-x 3
  set bathroom-dimension-y classroom-dimension-y
  set hall-dimension-x 35
  set hall-dimension-y corridor-dimension-y
  set road-dimension-x 40
  set principal-office-dimension-x 9
  set principal-office-dimension-y 6
  set teachers-room-dimension-x 15
  set teachers-room-dimension-y classroom-dimension-y
  set gym-dimension-x 16
  set gym-dimension-y 25
  set measurement-room-dimension-x 11
  set measurement-room-dimension-y classroom-dimension-y
end

to setup-contagion-variables
  set exhalation-mask-efficiency 0
  set inhalation-mask-efficiency 0
  set contamination-risk-decreased-with-mask 0

  if mask-type = "no mask"
    [ set fraction-of-population-wearing-mask 0 ]

  if mask-type = "surgical"
    [
      set exhalation-mask-efficiency 0.59
      set inhalation-mask-efficiency 0.59
      set contamination-risk-decreased-with-mask 0.47
    ]

  if mask-type = "ffp2"
    [
      set exhalation-mask-efficiency 0.9
      set inhalation-mask-efficiency 0.9
      set contamination-risk-decreased-with-mask 0.47
    ]

  set contamination-risk 0.024 * (1 - contamination-risk-decreased-with-mask * fraction-of-population-wearing-mask)

  set one-patch-in-meters 0.7

  set ventilation 0

  if ventilation-type-h-1 != "no ventilation"
    [ set ventilation ventilation-type-h-1 / 3600 ]

  set infectious-vaccinated-factor 1 - vaccine-efficacy
  set classroom-length-in-meters (classroom-dimension-x + 1) * one-patch-in-meters
  set classroom-width-in-meters (classroom-dimension-y + 1) * one-patch-in-meters
  set gym-length-in-meters (gym-dimension-x + 1) * one-patch-in-meters
  set gym-width-in-meters (gym-dimension-y + 1) * one-patch-in-meters
  set principal-office-length-in-meters (principal-office-dimension-x + 1) * one-patch-in-meters
  set principal-office-width-in-meters (principal-office-dimension-y + 1) * one-patch-in-meters
  set teachers-room-length-in-meters (teachers-room-dimension-x + 1) * one-patch-in-meters
  set teachers-room-width-in-meters (teachers-room-dimension-y + 1) * one-patch-in-meters
  set contact-space-length-in-meters one-patch-in-meters * 3
  set contact-space-width-in-meters one-patch-in-meters * 3
  set measurement-room-length-in-meters (measurement-room-dimension-x + 1) * one-patch-in-meters
  set measurement-room-width-in-meters (measurement-room-dimension-y + 1) * one-patch-in-meters
  set bathroom-length-in-meters (bathroom-dimension-x + 1) * one-patch-in-meters
  set bathroom-width-in-meters (bathroom-dimension-y + 1) * one-patch-in-meters
  set room-height 3.1
  set gym-height 7.32
  set classroom-area classroom-length-in-meters * classroom-width-in-meters
  set gym-area gym-length-in-meters * gym-width-in-meters
  set principal-office-area principal-office-length-in-meters * principal-office-width-in-meters
  set teachers-room-area teachers-room-length-in-meters * teachers-room-width-in-meters
  set contact-space-area contact-space-length-in-meters * contact-space-width-in-meters
  set measurement-room-area measurement-room-length-in-meters * measurement-room-width-in-meters
  set bathroom-area bathroom-length-in-meters * bathroom-width-in-meters
  set classroom-volume classroom-length-in-meters * classroom-width-in-meters * room-height
  set gym-volume gym-length-in-meters * gym-width-in-meters * gym-height
  set principal-office-volume principal-office-length-in-meters * principal-office-width-in-meters * room-height
  set teachers-room-volume teachers-room-length-in-meters * teachers-room-width-in-meters * room-height
  set contact-space-volume contact-space-area * 1
  set measurement-room-volume measurement-room-area * room-height
  set bathroom-volume bathroom-area * room-height

  set inhalation-rate-pure 0.521
  set vl 9
  set ngen-base 0.589
  set risk-const 410

  set activity-type-students 1.7777
  set activity-type-students-in-gym 6.1111
  set activity-type-teachers-in-classroom 6.1111
  set activity-type-teachers 2.5556
  set activity-type-principals 2.5556
  set activity-type-janitors 2.5556

  set inhalation-rate-students (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-students) / 1000
  set inhalation-rate-students-in-gym (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-students-in-gym) / 1000
  set inhalation-rate-teachers (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-teachers) / 1000
  set inhalation-rate-teachers-in-classroom (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-teachers-in-classroom) / 1000
  set inhalation-rate-principals (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-principals) / 1000
  set inhalation-rate-janitors (inhalation-rate-pure * (1 - inhalation-mask-efficiency * fraction-of-population-wearing-mask) * activity-type-janitors) / 1000

  set decay-rate-of-the-virus 0.636 / 3600
  set gravitational-settling-rate 0.39 / 3600
  set total-first-order-loss-rate ventilation + decay-rate-of-the-virus  + gravitational-settling-rate
end

to setup-temperature-measurement-variables
  set temperature-measurement-mean-time-in-seconds 0
  set temperature-measurement-std-in-seconds 0
  set num-school-janitors 0

  if temperature-measurement = "by hand"
    [
      set temperature-measurement-mean-time-in-seconds 10      ;in seconds (later I will turn it into ticks)
      set temperature-measurement-std-in-seconds 5             ;in seconds (later I will turn it into ticks)
      set num-school-janitors 2
      set rooms-aerosol lput "MR" rooms-aerosol
    ]

  if temperature-measurement = "termoscanner"
    [
      set temperature-measurement-mean-time-in-seconds 20      ;in seconds (later I will turn it into ticks)
      set temperature-measurement-std-in-seconds 10            ;in seconds (later I will turn it into ticks)
      set num-school-janitors 2
      set rooms-aerosol lput "MR" rooms-aerosol
    ]
end

to setup-screening-variables
  set screening-groups []
  set sub-screening-groups []

  if screening-policy = "1/4 of the class every week, in rotation"
    [
      set num-of-screening-group 4
      set num-of-sub-screening-group 1
    ]

  if screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week"
    [
      set num-of-screening-group 4
      set num-of-sub-screening-group 2
    ]

  if screening-policy = "all every week"
    [
      set num-of-screening-group 1
      set num-of-sub-screening-group 1
    ]

  set classrooms-in-quarantine []

  set after-days-swab-classrooms []
  set after-days-counters []
end

to setup-time-variables
  set last-principal-time-in-ticks 0

  set start-day-time-in-ticks 0
  set offset-between-days-in-ticks 60 * 60 / tick-duration-in-seconds                        ;1 hour in ticks

  set lesson-duration-in-ticks lesson-duration-in-minutes * 60 / tick-duration-in-seconds    ;50 or 60 minutes in ticks
  set interval-duration-in-ticks 15 * 60 / tick-duration-in-seconds                          ;15 minutes in ticks

  set offset-between-entrance-and-start-lessons-in-ticks 35 * 60 / tick-duration-in-seconds  ;35 minutes in ticks

  set supply-teachers []
  set supply-janitors []

  set staggered-time-in-ticks lesson-duration-in-ticks

  setup-day-school-variables
end

to setup-day-school-variables
  set finish-lessons-time-in-ticks-backup finish-lessons-time-in-ticks
  set start-lessons-time-in-ticks start-day-time-in-ticks + offset-between-entrance-and-start-lessons-in-ticks
  set finish-lessons-time-in-ticks start-lessons-time-in-ticks + interval-duration-in-ticks * 2 + lesson-duration-in-ticks * 6

  if finish-lessons-time-in-ticks-backup = 0
    [ set finish-lessons-time-in-ticks-backup finish-lessons-time-in-ticks ]

  set start-intervals-time-in-ticks list (start-lessons-time-in-ticks + lesson-duration-in-ticks * 2)  (start-lessons-time-in-ticks + interval-duration-in-ticks + lesson-duration-in-ticks * 4)

  set remain-time-for-interval-in-ticks n-values num-groups [-1]
  set remain-time-for-lesson-in-ticks n-values num-groups [lesson-duration-in-ticks]

  set next-group-activate 0
end

to setup-patches-variables
  ask patches
    [
      set classroom? false
      set corridor? false
      set bathroom? false
      set outdoor? false
      set principal-office? false
      set gym? false
      set teachers-room? false
      set measurement-room? false

      set desk? false
      set chair? false
      set teacher-chair? false
      set principal-chair? false
      set blackboard? false
      set entrance? false
      set exit? false
      set toilet? false
      set occupied? false
      set stair? false

      set measure-temperature-patch? false

      set room-name ""
      set floor-number 0
      set in-front-of ""

      set group-patch -1

      set plabel-color black
    ]
end

to setup-world
  let f 0

  let starting-floors-y-local starting-floors-y

  let starting-bathroom-x starting-floors-x + corridor-dimension-x * num-classrooms-per-floor + num-classrooms-per-floor
  let finish-bathroom-x starting-bathroom-x + bathroom-dimension-x
  let starting-bathroom-y starting-floors-y-local
  let finish-bathroom-y starting-floors-y-local + bathroom-dimension-y

  let starting-corridor-y starting-floors-y-local + classroom-dimension-y + 1
  let finish-corridor-y starting-corridor-y + corridor-dimension-y - 1

  let starting-hall-x starting-bathroom-x + bathroom-dimension-x + 1
  let finish-hall-x starting-hall-x + hall-dimension-x

  let starting-principal-office-x starting-hall-x + 3
  let finish-principal-office-x starting-principal-office-x + principal-office-dimension-x
  let starting-principal-office-y finish-corridor-y + 1
  let finish-principal-office-y starting-principal-office-y + principal-office-dimension-y

  let starting-gym-x finish-hall-x - gym-dimension-x - 1
  let finish-gym-x finish-hall-x - 1
  let starting-gym-y finish-corridor-y + 1
  let finish-gym-y starting-gym-y + gym-dimension-y

  let starting-teachers-room-x starting-hall-x + 1
  let finish-teachers-room-x starting-teachers-room-x + teachers-room-dimension-x
  let starting-teachers-room-y starting-floors-y-local
  let finish-teachers-room-y starting-teachers-room-y + teachers-room-dimension-y

  let starting-teachers-bathroom-x finish-teachers-room-x + 2
  let finish-teachers-bathroom-x starting-teachers-bathroom-x + bathroom-dimension-x
  let starting-teachers-bathroom-y starting-teachers-room-y
  let finish-teachers-bathroom-y finish-teachers-room-y

  let starting-measurement-room-x finish-teachers-bathroom-x + 2
  let finish-measurement-room-x starting-measurement-room-x + measurement-room-dimension-x
  let starting-measurement-room-y starting-floors-y-local
  let finish-measurement-room-y starting-teachers-room-y + measurement-room-dimension-y

  let starting-outdoor-x finish-hall-x

  let school-entrance list (starting-corridor-y + floor (corridor-dimension-y / 2)) (starting-corridor-y + floor (corridor-dimension-y / 2) - 1)


  setup-outdoor starting-outdoor-x school-entrance

  repeat num-floors
    [
      setup-classrooms starting-floors-x starting-floors-y-local finish-bathroom-x finish-corridor-y f

      ask patches
        [
          if f = 0
            [
              if pxcor >= starting-hall-x and
                 pxcor <= finish-hall-x and
                 pycor >= starting-corridor-y and
                 pycor <= finish-corridor-y
                [
                  set pcolor orange - 2
                  set corridor? true
                  set floor-number f + 1
                ]

              if pxcor = starting-outdoor-x + 1 and
                 member? pycor school-entrance
                [
                  set pcolor cyan + 1
                  set plabel "E"
                  set entrance? true
                  set room-name "E"
                  set floor-number f + 1
                ]

              setup-principal-office starting-principal-office-x finish-principal-office-x starting-principal-office-y finish-principal-office-y
              setup-gym starting-gym-x finish-gym-x starting-gym-y finish-gym-y
              setup-teachers-room starting-teachers-room-x finish-teachers-room-x starting-teachers-room-y finish-teachers-room-y
              setup-teachers-bathroom starting-teachers-bathroom-x finish-teachers-bathroom-x starting-teachers-bathroom-y finish-teachers-bathroom-y
              setup-measurement-room starting-measurement-room-x finish-measurement-room-x starting-measurement-room-y finish-measurement-room-y
            ]

          if pxcor >= starting-bathroom-x and
             pxcor <= finish-bathroom-x and
             pycor >= starting-bathroom-y and
             pycor <= finish-bathroom-y
            [
              set pcolor cyan - 1
              set bathroom? true
              set room-name word (f + 1) "T"
              set floor-number f + 1

              if pxcor = finish-bathroom-x and
                 member? pycor (list (starting-floors-y-local + 1) (starting-floors-y-local + 3) (starting-floors-y-local + 5) (starting-floors-y-local + 7) (starting-floors-y-local + 9))
                [
                  set pcolor cyan - 3
                  set toilet? true
                ]
            ]

          if pxcor = starting-bathroom-x + 1 and
             pycor = starting-corridor-y
            [
              set pcolor cyan + 1
              set plabel word (f + 1) "T"
              set entrance? true
              set bathroom? true
              set room-name word (f + 1) "T"
            ]

          if num-floors > 1 and
             member? pxcor (list (starting-bathroom-x + 1) (starting-bathroom-x + 2) (starting-bathroom-x + 3)) and
             member? pycor list finish-corridor-y (finish-corridor-y - 1)
            [
              set pcolor orange - 4
              set stair? true
            ]
        ]

      set rooms-aerosol lput (word (f + 1) "T") rooms-aerosol

      set f f + 1

      set starting-floors-y-local starting-floors-y + f * (classroom-dimension-y + corridor-dimension-y + 4)

      set starting-corridor-y starting-floors-y-local + classroom-dimension-y + 1
      set finish-corridor-y starting-corridor-y + corridor-dimension-y - 1

      set starting-bathroom-y starting-floors-y-local
      set finish-bathroom-y starting-floors-y-local + bathroom-dimension-y
    ]

  setup-queue-variables starting-measurement-room-x finish-measurement-room-x starting-measurement-room-y finish-measurement-room-y
end

to setup-outdoor [sx school-entrance]
  ask patches
    [
      if pxcor >= sx and
         pxcor <= sx + road-dimension-x and
         member? pycor school-entrance
        [
          set pcolor gray
          set outdoor? true
        ]

      if (pxcor >= sx + 1 and not member? pycor school-entrance) or
          pxcor >= sx + road-dimension-x + 1
        [
          set pcolor lime - 2
          set outdoor? true
        ]
    ]

  let f 0
  let outdoor-classroom-patches sort patches with [ member? pxcor (list (max-pxcor - 56) (max-pxcor - 39) (max-pxcor - 22) (max-pxcor - 5)) and member? pycor (list 10 35 60) ]

  if staggered-admissions?
  [
    repeat num-floors
      [
        let c 0

        repeat num-classrooms-per-floor
          [
            ask first outdoor-classroom-patches
              [
                set pcolor cyan + 1
                set plabel word (f + 1) item c classroom-letters
                set room-name word (f + 1) item c classroom-letters
              ]

            set outdoor-classroom-patches but-first outdoor-classroom-patches
            set c c + 1
          ]
        set f f + 1
      ]
  ]
end

to setup-classrooms [sx sy finish-bathroom-x finish-corridor-y floor-index]
  let c 0
  let desks []
  let starting-classroom-y sy
  let finish-classroom-y (starting-classroom-y + classroom-dimension-y)

  repeat num-classrooms-per-floor
    [
      let actual-room-name word (floor-index + 1) item c classroom-letters

      ask patches
        [
          let starting-classroom-x sx + (c * (classroom-dimension-x + 2))
          let finish-classroom-x (starting-classroom-x + classroom-dimension-x)

          let x-desks get-x-desks starting-classroom-x
          let x-chairs get-x-chairs starting-classroom-x

          if (pxcor >= starting-classroom-x and (pxcor <= finish-classroom-x + 1 or (pxcor <= finish-bathroom-x and c = num-classrooms-per-floor - 1))) and
              pycor >= finish-classroom-y + 1 and
              pycor <= finish-corridor-y
            [
              set pcolor orange - 2
              set corridor? true
              set in-front-of actual-room-name
              set floor-number floor-index + 1

              if pxcor = starting-classroom-x + 1 and
                 pycor = starting-classroom-y + classroom-dimension-y + 1
                [
                  set pcolor cyan + 1
                  set plabel actual-room-name
                  set entrance? true
                  set classroom? true
                  set room-name actual-room-name
                ]
            ]

          if pxcor >= starting-classroom-x and
             pxcor <= finish-classroom-x and
             pycor >= starting-classroom-y and
             pycor <= finish-classroom-y
            [
              set pcolor orange + 3
              set classroom? true
              set room-name actual-room-name
              set floor-number floor-index + 1

            ifelse spaced-desks?
              [ set desks (list starting-classroom-y (starting-classroom-y + 2) (starting-classroom-y + 4) (starting-classroom-y + 6) (starting-classroom-y + 8) (starting-classroom-y + 10)) ]
              [ set desks (list starting-classroom-y (starting-classroom-y + 1) (starting-classroom-y + 4) (starting-classroom-y + 5) (starting-classroom-y + 6) (starting-classroom-y + 9) (starting-classroom-y + 10)) ]

              if member? pxcor x-desks and
                 member? pycor desks
                [
                  set pcolor 32
                  set desk? true
                ]

              if member? pxcor x-chairs and
                 member? pycor desks
                [ set chair? true ]

              if (pxcor = (starting-classroom-x + 1) and
                  member? pycor (list (starting-classroom-y + 4) (starting-classroom-y + 5) (starting-classroom-y + 6)))
                [
                  set pcolor 34
                  set desk? true
                ]

              if pxcor = starting-classroom-x and
                 pycor = starting-classroom-y + 5
                [ set teacher-chair? true ]

              if pxcor = starting-classroom-x and
                 member? pycor list (starting-classroom-y + 2) (starting-classroom-y + 3)
                [
                  set pcolor cyan + 1
                  set plabel "B"
                  set blackboard? true
                ]
            ]
        ]

      set rooms-aerosol lput actual-room-name rooms-aerosol
      set classroom-name lput actual-room-name classroom-name

      set c c + 1
    ]
end

to setup-principal-office [sx fx sy fy]
  if pxcor >= sx and
     pxcor <= fx and
     pycor >= sy and
     pycor <= fy
    [
      set pcolor gray
      set principal-office? true
      set room-name "PO"
      set floor-number 1
    ]

  if pxcor = sx + 3 and
     pycor = sy - 1
    [
      set pcolor cyan + 1
      set plabel "PO"
      set room-name "PO"
      set entrance? true
      set principal-office? true
    ]

    if member? pxcor list (sx + 4) (sx + 5) and
       pycor = fy - 1
    [
      set pcolor 34
      set desk? true
    ]

    if member? pxcor list (sx + 4) (sx + 5) and
       pycor = fy
      [ set principal-chair? true ]

    if pxcor = fx and
       member? pycor (list (sy + 4) (sy + 2) sy)
      [ set chair? true ]

    if pxcor = sx and
       member? pycor (list (sy + 4) (sy + 2) sy)
      [ set chair? true ]
end

to setup-gym [sx fx sy fy]
  if pxcor >= sx and
     pxcor <= fx and
     pycor >= sy and
     pycor <= fy
    [
      set pcolor red + 1
      set gym? true
      set room-name "G"
      set floor-number 1
    ]

    if member? pxcor list (sx + 8) (sx + 9) and
       pycor = sy - 1
    [
      set pcolor cyan + 1
      set plabel "G"
      set room-name "G"
      set entrance? true
      set gym? true
    ]
end

to setup-teachers-room [sx fx sy fy]
  if pxcor >= sx and
     pxcor <= fx and
     pycor >= sy and
     pycor <= fy
    [
      set pcolor cyan + 1
      set teachers-room? true
      set room-name "TR"
      set floor-number 1
    ]

    if pxcor = sx + 5  and
       pycor = fy + 1
    [
      set pcolor cyan + 1
      set plabel "TR"
      set room-name "TR"
      set entrance? true
      set teachers-room? true
    ]

  if pxcor >= sx + 2 and
     pxcor <= fx - 2 and
     pycor >= sy + 2 and
     pycor <= fy - 2
    [
      set pcolor 34
      set desk? true
    ]

  if (member? pxcor (list (sx + 2) (sx + 4) (sx + 6) (fx - 2) (fx - 4) (fx - 6)) and member? pycor list (fy - 1) (sy + 1)) or
     (member? pxcor list (sx + 1) (fx - 1) and member? pycor (list (sy + 3) (sy + 5) (fy - 3)))
    [ set teacher-chair? true ]
end

to setup-teachers-bathroom [sx fx sy fy]
  if pxcor >= sx and
     pxcor <= fx and
     pycor >= sy and
     pycor <= fy
    [
      set pcolor cyan - 1
      set bathroom? true
      set room-name "TT"
      set floor-number 1

      if pxcor = fx and
         member? pycor (list (sy + 1) (sy + 3) (sy + 5) (sy + 7) (sy + 9))
        [
          set pcolor cyan - 3
          set toilet? true
        ]
    ]

    if pxcor = sx + 1 and
       pycor = fy + 1
        [
          set pcolor cyan + 1
          set plabel "TT"
          set entrance? true
          set bathroom? true
          set room-name "TT"
        ]
end

to setup-measurement-room [sx fx sy fy]
  if pxcor >= sx and
     pxcor <= fx and
     pycor >= sy and
     pycor <= fy
    [
      set pcolor orange + 2
      set measurement-room? true
      set room-name "MR"
      set floor-number 1

      if member? pxcor (list sx (sx + 1) (sx + 2) (sx + 3) fx (fx - 1) (fx - 2) (fx - 3)) and
         pycor = sy + 3
        [
          set pcolor 32
          set desk? true
        ]

      if member? pxcor list (sx + 1) (fx - 1) and
         pycor = sy + 2
        [ set chair? true ]

      if member? pxcor list (sx + 2) (fx - 1) and
         pycor = sy + 4
        [ set measure-temperature-patch? true ]
    ]

  if member? pxcor list (fx - 1) (fx - 2) and
     pycor = fy + 1
    [
      set pcolor cyan + 1
      set plabel "M1"
      set measurement-room? true
      set room-name "MR"
    ]

  if member? pxcor list (sx + 1) (sx + 2) and
     pycor = fy + 1
    [
      set pcolor cyan + 1
      set plabel "M2"
      set measurement-room? true
      set room-name "MR"
    ]

  ask patch (fx - 2) (fy + 1) [ set exit? true ]
  ask patch (fx - 1) (fy + 1) [ set entrance? true ]
  ask patch (sx + 1) (fy + 1) [ set exit? true ]
  ask patch (sx + 2) (fy + 1) [ set entrance? true ]

end

to setup-queue-variables [sx fx sy fy]
  set patches-queue1 []
  set patches-queue2 []
  let pxcor-temp fx - 1
  let pycor-temp fy - 6

  while [pycor-temp < fy + 4]
    [
      set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1

      set pycor-temp pycor-temp + 1
    ]

  while [pxcor-temp < max-pxcor - 1]
    [
      set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1

      set pxcor-temp pxcor-temp + 1
    ]

  set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1
  set pycor-temp pycor-temp - 1
  set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1
  set pycor-temp pycor-temp - 1
  set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1

  while [pxcor-temp >= sx + 15 ]
    [
      set patches-queue1 lput patch pxcor-temp pycor-temp patches-queue1

      set pxcor-temp pxcor-temp - 1
    ]


  set pxcor-temp sx + 2
  set pycor-temp fy - 6

  while [pycor-temp < fy + 5]
    [
      set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2

      set pycor-temp pycor-temp + 1
    ]

  while [pxcor-temp < max-pxcor - 1 ]
    [
      set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2

      set pxcor-temp pxcor-temp + 1
    ]

  set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2
  set pycor-temp pycor-temp + 1
  set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2
  set pycor-temp pycor-temp + 1
  set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2

  while [pxcor-temp >= sx + 15 ]
    [
      set patches-queue2 lput patch pxcor-temp pycor-temp patches-queue2

      set pxcor-temp pxcor-temp - 1
    ]
end

to setup-agents
  set num-teachers get-num-teachers
  set num-agents num-students + num-teachers + num-school-janitors + 1
  set num-susceptible num-agents

  setup-students
  setup-screening-students
  setup-teachers
  setup-principal
  setup-janitors
  setup-vaccinated-agents
  print-day-results
  setup-infected
end

to setup-students
  set-default-shape students "person"

  let i 0

  repeat num-classrooms-per-floor * num-floors
    [
      let actual-room-name (word (floor (i / num-classrooms-per-floor) + 1) item floor (i mod num-classrooms-per-floor) classroom-letters)
      let classroom-desks sort-by [ [a-patch b-patch] -> [pxcor] of a-patch < [pxcor] of b-patch or ([pxcor] of a-patch = [pxcor] of b-patch and [pycor] of a-patch < [pycor] of b-patch) ] patches with [ chair? and room-name = actual-room-name ]
      let actual-screening-group 0
      let actual-sub-screening-group 0

      create-students students-per-classroom
        [
          set desk item (who mod students-per-classroom) classroom-desks
          set classroom actual-room-name
          set floor-idx get-floor-by-classroom classroom

          set age-group "Young"
          set staggered-group i mod num-groups
          set screening-group actual-screening-group
          set sub-screening-group actual-sub-screening-group

          set blackboard-time-in-ticks 0
          set principal-time-in-ticks 0

          ask patches with [ room-name = [classroom] of myself ]
            [ set group-patch [staggered-group] of myself ]

          setup-common-attributes
        ]

      ask n-of (floor (students-per-classroom * (dad-% / 100))) students with [ classroom = actual-room-name ]
        [
          set dad? true
          set quarantined? true
          set num-susceptible num-susceptible - 1
          set num-susceptible-in-quarantine num-susceptible-in-quarantine + 1
        ]

      set i i + 1
    ]
end

to setup-screening-students
  if screening-policy != "no screening"
    [
      foreach classroom-name
        [
          c-name -> let actual-screening-group 0
                    let actual-sub-screening-group 1
                    set screening-groups (list 1)
                    set sub-screening-groups (list 1)

                    if screening-policy = "1/4 of the class every week, in rotation" or
                       screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week"
                      [ set screening-groups shuffle (list 1 2 3 4) ]

                    if screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week"
                      [ set sub-screening-groups (list 1 2) ]

                    if screening-policy != "1/4 of the class every week, in rotation, spread over two days of the week"
                      [ set second-day-of-week first-day-of-week ]

                    ask n-of floor ((floor (students-per-classroom * (1 - dad-% / 100))) * (screening-adhesion-% / 100)) students with [ classroom = c-name and not quarantined? ]
                      [
                        set screening-adhesion? true
                        set actual-screening-group (actual-screening-group mod num-of-screening-group) + 1
                        set screening-group actual-screening-group
                        set sub-screening-group actual-sub-screening-group

                        if actual-screening-group = num-of-screening-group
                          [ set actual-sub-screening-group (actual-sub-screening-group mod num-of-sub-screening-group) + 1 ]
                      ]
        ]
    ]
end

to setup-teachers
  set-default-shape teachers "person"

  let i 0

  create-teachers num-teachers
    [
      ifelse random 100 < prob-old-teachers * 100
        [ set age-group "Old" ]
        [ set age-group "Regular" ]

      set gym-teacher? false
      set supply? false

      set teacher-idx item (who mod num-teachers) effective-teachers-flat

      set classroom "-"

      set personal-classrooms-scheduling n-values 5 [n-values (6 + num-groups - 1) ["-"]]
      set day-scheduling n-values (6 + num-groups - 1) ["-"]
      set first-day-of-work 0

      set update? false

      set i i + 1
    ]

  create-personal-classrooms-scheduling

  ask teachers
    [ setup-common-attributes ]
end

to setup-principal
  set-default-shape principals "person"

  create-principals 1
    [
      set desk one-of patches with [ principal-chair? and principal-office? ]
      set classroom [room-name] of desk
      set floor-idx get-floor-by-classroom classroom

      ifelse random 100 < prob-old-teachers * 100
        [ set age-group "Old" ]
        [ set age-group "Regular" ]

      set staggered-group -1

      setup-common-attributes
    ]
end

to setup-janitors
  set-default-shape janitors "person"

  let desks sort-on [pxcor] patches with [ chair? and measurement-room? ]

  create-janitors num-school-janitors
    [
      set desk item (who mod num-school-janitors) desks
      set classroom [room-name] of desk
      set floor-idx get-floor-by-classroom classroom

      ifelse random 100 < prob-old-janitors * 100
        [ set age-group "Old" ]
        [ set age-group "Regular" ]

      set staggered-group -1

      setup-common-attributes
    ]
end

to setup-common-attributes
  set color lime - 3

  let next-classroom classroom

  if breed = teachers
    [ set next-classroom first item (day mod 5) personal-classrooms-scheduling ]

  let staggered-condition (member? breed list teachers students and next-classroom != "-")

  ifelse staggered-admissions? and
         staggered-condition
    [
      let init-patch no-patches

      ask one-of patches with [ outdoor? and room-name = next-classroom ]
        [ set init-patch one-of patches in-radius 5 ]
      setxy [pxcor] of init-patch [pycor] of init-patch
    ]
    [
      let start-patch one-of patches with [ not entrance? and outdoor? ]
      setxy [pxcor] of start-patch [pycor] of start-patch
    ]

  set susceptible? true
  set exposed? false
  set infected? false
  set removed? false
  set quarantined? false
  set vaccinated? false
  set screening-adhesion? false

  set screening-group 0
  set sub-screening-group 0

  set toilet []

  set toilet-time-in-ticks 0

  set temperature-time-in-ticks 0
  set temperature-already-measured? false

  if temperature-measurement = "no measurement"
    [ set temperature-already-measured? true ]

  set queue 0
  set queue-position -1

  ifelse breed = janitors
    [ set move-time-in-ticks 0 ]
    [ set move-time-in-ticks random offset-between-entrance-and-start-lessons-in-ticks + 1 ]

  set remain-incubation-days 0
  set remain-infected-days 0
  set remain-quarantine-days 0

  set dad? false

  set gym-hour? false

  set targets lput patch-here []

  set hidden? true
end

to setup-vaccinated-agents
  if vaccinated-students?
    [
      foreach classroom-name
        [
          c-name -> ask n-of (floor (students-per-classroom * fraction-of-vaccinated-students)) students with [ classroom = c-name ]
                      [
                        ifelse vaccine-efficacy < 1
                          [
                            set susceptible? true
                            set num-vaccinated-susceptible num-vaccinated-susceptible + 1
                          ]
                          [
                            set susceptible? false
                            set num-vaccinated-removed num-vaccinated-removed + 1
                          ]

                        set vaccinated? true
                        set num-susceptible num-susceptible - 1
                        set color magenta - 1
                      ]
        ]
    ]

  if vaccinated-teachers?
    [
      ask n-of (floor (num-teachers * fraction-of-vaccinated-teachers)) teachers
        [
          ifelse vaccine-efficacy < 1
            [
              set susceptible? true
              set num-vaccinated-susceptible num-vaccinated-susceptible + 1
            ]
            [
              set susceptible? false
              set num-vaccinated-removed num-vaccinated-removed + 1
            ]

          set vaccinated? true
          set num-susceptible num-susceptible - 1
          set color magenta - 1
        ]
    ]

  if vaccinated-principals?
    [
      ask principals
        [
          ifelse vaccine-efficacy < 1
            [
              set susceptible? true
              set num-vaccinated-susceptible num-vaccinated-susceptible + 1
            ]
            [
              set susceptible? false
              set num-vaccinated-removed num-vaccinated-removed + 1
            ]

          set vaccinated? true
          set num-susceptible num-susceptible - 1
          set color magenta - 1
        ]
    ]

  if vaccinated-janitors?
    [
      ask n-of (floor (num-school-janitors * fraction-of-vaccinated-janitors)) janitors
        [
          ifelse vaccine-efficacy < 1
            [
              set susceptible? true
              set num-vaccinated-susceptible num-vaccinated-susceptible + 1
            ]
            [
              set susceptible? false
              set num-vaccinated-removed num-vaccinated-removed + 1
            ]

          set vaccinated? true
          set num-susceptible num-susceptible - 1
          set color magenta - 1
        ]
    ]
end

to setup-infected
  let initial-infected-breed turtles

  if init-infected-type = "students"
    [
      set initial-infected-breed students

      if init-infected > num-students
        [
          user-message "There aren't enough student. Please, select another type of initial infected agents."
          stop
        ]
    ]

  if init-infected-type = "teachers"
    [
      set initial-infected-breed teachers with [ first-day-of-work <= days-of-simulation ]

      if init-infected > count initial-infected-breed
        [
          user-message "There aren't enough teachers. Please, select another type of initial infected agents."
          stop
        ]
    ]

  if init-infected-type = "principals"
    [
      set initial-infected-breed principals

      if init-infected > 1
        [
          user-message "There aren't enough principals. Please, select another type of initial infected agents."
          stop
        ]
    ]

  if init-infected-type = "janitors"
    [
      ifelse num-school-janitors > 0
        [ set initial-infected-breed janitors ]
        [
          user-message "There are no janitors. Please, select another type of initial infected agents."
          stop
        ]

      if init-infected > num-school-janitors
        [
          user-message "There aren't enough janitors. Please, select another type of initial infected agents."
          stop
        ]
    ]

  if count initial-infected-breed with [ not quarantined? and susceptible? ] != 0
    [
      ask n-of init-infected initial-infected-breed with [ not quarantined? and susceptible? ]
        [ get-infected true ]
    ]
end



;run phase
to go
  end-of-day-computation

  if stop-simulation?
    [ stop ]

  if next-group-activate < num-groups
    [ start-group ]

  start-agents

  move

  ;Uncomment if you want to measure the temperature at the entrance (meaningful only with a tick equal to 4, 8 or 12 seconds)
  ;It's necessary to introduce a mechanism for symptoms detection!
  ;if temperature-measurement != "no-measurement"
  ;  [ measure-temperature ]

  if ticks >= start-lessons-time-in-ticks
    [ update-lessons ]

  accumulate-aerosol-all-rooms
  accumulate-contact-with-infected
  ;Uncomment if you want to count the contacts (with 4 seconds tick, otherwise we lose a lot of contacts)
  ;verify-contact

  if next-group-activate > 0
    [ update-school-clock ]

  tick
end

to end-of-day-computation
  if ticks >= finish-lessons-time-in-ticks-backup
    [
      infect-aerosol
      infect-with-contact

      if stop-day and
         not print-day?
        [
          print-day-results
          set print-day? true
        ]
    ]
end

to-report stop-simulation?
  let stop-seir-condition num-infected + num-exposed + num-vaccinated-infected + num-vaccinated-exposed = 0

  if outside-contagion?
    [ set stop-seir-condition num-susceptible + num-exposed + num-infected +
          num-vaccinated-susceptible + num-vaccinated-exposed + num-vaccinated-infected +
          num-susceptible-in-quarantine + num-susceptible-in-quarantine-external-1 + num-susceptible-in-quarantine-external-2 +
          num-vaccinated-susceptible-in-quarantine + num-vaccinated-susceptible-in-quarantine-external-1 + num-vaccinated-susceptible-in-quarantine-external-2 = 0 ]

  if stop-seir-condition or
     stop-condition
    [
      complete-simulation
      report true
    ]

  report false
end

to complete-simulation
  while [day <= days-of-simulation]
    [
      print-day-results

      set day day + 1

      update-quarantine

      ask turtles with [ exposed? or infected? ]
		    [ update-infected ]
		
		  let first-day-screening day - (position first-day-of-week days-of-week + 1)
      let second-day-screening day - (position second-day-of-week days-of-week + 1)
		
		  after-days-screening first-day-screening second-day-screening		
		
		  ask turtles
        [ external-screening ]

      if screening-policy != "no screening"
        [ school-screening-complete-simulation first-day-screening second-day-screening ]
    ]
end

to start-group
  let start-group-day-time start-day-time-in-ticks + (next-group-activate * staggered-time-in-ticks)

  if ticks = start-group-day-time
    [
      ifelse next-group-activate = 0
        [
          set print-day? false

          let num-days get-num-days

          set school-day school-day + 1
  	
  	      let first-day-screening school-day - (position first-day-of-week days-of-week + 1)
  	      let second-day-screening school-day - (position second-day-of-week days-of-week + 1)
  	
  	      sanitize-school

          let i 0
	        repeat num-days
	          [	
	            reset-school-clock
	
              update-quarantine

              after-days-screening first-day-screening second-day-screening

 	            ask turtles
    	          [ update-infected-and-outside-contagion ]

              ask turtles
                [ external-screening ]

              if weekend? and
                 i < 2
	              [ print-day-results ]

              set i i + 1
            ]

          set weekend? false

          ask teachers with [staggered-group >= 0]
            [ update-day-scheduling ]

          ask janitors with [ not quarantined? ]
            [ setup-initial-targets ]

          if screening-policy != "no screening"
            [ school-screening first-day-screening second-day-screening ]
        ]
        [ update-teachers-classroom next-group-activate ]

      set end-day? replace-item next-group-activate end-day? false
      set next-group-activate next-group-activate + 1
    ]
end

to update-quarantine
  ask turtles with [ quarantined? ]
    [
	    set remain-quarantine-days remain-quarantine-days - 1

		  if remain-quarantine-days = 0
		    [ remove-from-quarantine ]
		]
end

to sanitize-school
  ask turtles
    [
      set cumulative-quanta-inhaled 0
      set cumulative-quanta-inhaled-in-classroom 0
	    set cumulative-quanta-inhaled-in-gym 0
	    set cumulative-quanta-inhaled-in-measurement-room 0
	    set cumulative-quanta-inhaled-in-principal-office 0
	    set cumulative-quanta-inhaled-in-teachers-room 0
	    set cumulative-quanta-inhaled-in-bathroom 0
    ]

  ask patches
    [ set cumulative-quanta-concentration 0 ]

  set contact-time-with-infected-matrix-in-ticks matrix:make-constant (num-agents * 2) (num-agents * 2) 0
  set is-in-contact-matrix? matrix:make-constant (num-agents * 2) (num-agents * 2) 0
  set contact-time-matrix-in-ticks matrix:make-constant (num-agents * 2) (num-agents * 2) 0
  set number-of-contact-matrix matrix:make-constant (num-agents * 2) (num-agents * 2) 0

  set num-active-agents n-values 5 [0]
  set mean-quanta-inhaled n-values 5 [0]
  set mean-quanta-inhaled-in-classroom n-values 5 [0]
  set mean-quanta-inhaled-in-gym n-values 5 [0]
  set mean-quanta-inhaled-in-measurement-room n-values 5 [0]
  set mean-quanta-inhaled-in-principal-office n-values 5 [0]
  set mean-quanta-inhaled-in-teachers-room n-values 5 [0]
  set mean-quanta-inhaled-in-bathroom n-values 5 [0]
end

to update-infected-and-outside-contagion
  if exposed? or
		 infected?
    [ update-infected ]

  if outside-contagion? and
	   susceptible? and
	   not quarantined?
	  [ outside-contagion ]

  set floor-idx get-floor-by-classroom classroom
end

to external-screening
  if external-screening? and
     not quarantined? and
		 breed = students
	  [
		  external-screening-1
		
		  if not quarantined? and
         infected?
		    [ external-screening-2 ]
		]
end

to school-screening-complete-simulation [first-day-screening second-day-screening]
  if first-day-screening mod 7 = 0
    [
      set num-of-screened-students num-of-screened-students + count students with [ not quarantined? and screening-group = item next-screening-group screening-groups and sub-screening-group = item next-sub-screening-group sub-screening-groups ]

      set next-screening-group (next-screening-group + 1) mod num-of-screening-group
      set next-sub-screening-group (next-sub-screening-group + 1) mod num-of-sub-screening-group
    ]

  if screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week"
    [
      if second-day-screening mod 7 = 0
        [
          set num-of-screened-students num-of-screened-students + count students with [ not quarantined? and screening-group = item next-screening-group screening-groups and sub-screening-group = item next-sub-screening-group sub-screening-groups ]

          set next-sub-screening-group (next-sub-screening-group + 1) mod num-of-sub-screening-group
          if next-sub-screening-group = 1
            [ set next-screening-group (next-screening-group + 1) mod num-of-screening-group ]
        ]
    ]
end

to school-screening [first-day-screening second-day-screening]
  if first-day-screening mod 5 = 0
    [ screening ]

  if screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week"
    [
      if second-day-screening mod 5 = 0
        [ screening ]
    ]
end

to screening
  foreach classroom-name
    [
      c-name -> let index position c-name after-days-swab-classrooms
                let remaining-days -1
                if index != false
                  [ set remaining-days item index after-days-counters ]

                ifelse remaining-days != number-of-after-days-special-swab or
                       remaining-days != 0
                  [
                    let screened-students students with [ not quarantined? and classroom = c-name and screening-group = item next-screening-group screening-groups and sub-screening-group = item next-sub-screening-group sub-screening-groups ]
                    let infected-group students with [ classroom = c-name and screening-group = item next-screening-group screening-groups and sub-screening-group = item next-sub-screening-group sub-screening-groups and infected? and not quarantined? ]
                    set num-of-screened-students num-of-screened-students + count screened-students
                    set num-of-positive-students num-of-positive-students + count infected-group

                    if count infected-group > 0
                      [
                        ifelse not whole-classroom-quarantined?
                        [
                          let infected-already-in-quarantine students with [ classroom = c-name and quarantined? ]

                          ifelse count infected-group + count infected-already-in-quarantine >= num-infected-needed-to-quarantine-whole-classroom
                            [
                              ask infected-already-in-quarantine
                                [ set remain-quarantine-days num-of-quarantine-days ]

                              put-classroom-in-quarantine c-name false false

                              if index != false
                                [
                                  set after-days-swab-classrooms remove-item index after-days-swab-classrooms
                                  set after-days-counters remove-item index after-days-counters
                                ]
                            ]
                            [
                              ask infected-group
                                [ put-student-in-quarantine false false ]

                              set infected-already-in-quarantine students with [ classroom = c-name and quarantined? ]

                              swab-other-students students with [classroom = c-name and (screening-group != item next-screening-group screening-groups or sub-screening-group != item next-sub-screening-group sub-screening-groups) and not quarantined?] infected-already-in-quarantine c-name false
                            ]
                        ]
                        [ put-classroom-in-quarantine c-name false false ]
                      ]
                  ]
                  [
                    if remaining-days = 0
                      [
                        set after-days-swab-classrooms remove-item index after-days-swab-classrooms
                        set after-days-counters remove-item index after-days-counters
                      ]
                  ]
    ]

  set next-sub-screening-group (next-sub-screening-group + 1) mod num-of-sub-screening-group
  if next-sub-screening-group = 1
    [ set next-screening-group (next-screening-group + 1) mod num-of-screening-group ]
end

to external-screening-1
  if random 10000 < prob-external-screening-1 * 10000
    [
      set num-of-screened-students-external-1 num-of-screened-students-external-1 + 1

      if infected?
        [
          set num-of-positive-students-external-1 num-of-positive-students-external-1 + 1
          let quarantined-students-in-the-same-classroom students with [ classroom = [classroom] of myself and quarantined? ]

          ifelse not whole-classroom-quarantined?
          [
            ifelse count quarantined-students-in-the-same-classroom + 1 >= num-infected-needed-to-quarantine-whole-classroom
              [
                ask quarantined-students-in-the-same-classroom
                  [ set remain-quarantine-days num-of-quarantine-days ]

                put-classroom-in-quarantine classroom true false

                let index position classroom after-days-swab-classrooms
                if index != false
                  [
                    set after-days-swab-classrooms remove-item index after-days-swab-classrooms
                    set after-days-counters remove-item index after-days-counters
                  ]
              ]
              [
                put-student-in-quarantine true false

                set quarantined-students-in-the-same-classroom students with [ classroom = [classroom] of myself and quarantined? ]

                swab-other-students students with [classroom = [classroom] of myself and not quarantined? and who != [who] of myself] quarantined-students-in-the-same-classroom classroom false
              ]
          ]
          [ put-classroom-in-quarantine classroom true false ]
        ]
    ]
end

to external-screening-2
  if random 10000 < prob-external-screening-2 * 10000
    [
      set num-of-screened-students-external-2 num-of-screened-students-external-2 + 1
      set num-of-positive-students-external-2 num-of-positive-students-external-2 + 1

      let quarantined-students-in-the-same-classroom students with [ classroom = [classroom] of myself and quarantined? ]

      ifelse not whole-classroom-quarantined?
      [
        ifelse count quarantined-students-in-the-same-classroom + 1 >= num-infected-needed-to-quarantine-whole-classroom
          [
            ask quarantined-students-in-the-same-classroom
              [ set remain-quarantine-days num-of-quarantine-days ]

            put-classroom-in-quarantine classroom false true

            let index position classroom after-days-swab-classrooms
            if index != false
              [
                set after-days-swab-classrooms remove-item index after-days-swab-classrooms
                set after-days-counters remove-item index after-days-counters
              ]
          ]
          [
            put-student-in-quarantine false true

            set quarantined-students-in-the-same-classroom students with [ classroom = [classroom] of myself and quarantined? ]

            swab-other-students students with [classroom = [classroom] of myself and not quarantined? and who != [who] of myself] quarantined-students-in-the-same-classroom classroom false
          ]
      ]
      [ put-classroom-in-quarantine classroom false true ]
    ]
end

to swab-other-students [students-list quarantined-students-in-the-same-classroom c-name special-swab]
  let infected-students students-list with [ infected? ]
  set num-of-screened-students num-of-screened-students + count students-list
  set num-of-positive-students num-of-positive-students + count infected-students

  ifelse count infected-students > 0
    [
      ifelse count infected-students + count quarantined-students-in-the-same-classroom >= num-infected-needed-to-quarantine-whole-classroom
        [
          ask quarantined-students-in-the-same-classroom
            [ set remain-quarantine-days num-of-quarantine-days ]

          put-classroom-in-quarantine c-name false false
        ]
        [
          ask infected-students
            [ put-student-in-quarantine false false ]

          if not special-swab and
             position c-name after-days-swab-classrooms = false
            [
              set after-days-swab-classrooms lput c-name after-days-swab-classrooms
              set after-days-counters lput number-of-after-days-special-swab after-days-counters
            ]
        ]
    ]
    [
      if not special-swab and
         position c-name after-days-swab-classrooms = false
        [
          set after-days-swab-classrooms lput c-name after-days-swab-classrooms
          set after-days-counters lput number-of-after-days-special-swab after-days-counters
        ]
    ]
end

to after-days-screening [first-day-screening second-day-screening]
  let i 0
  while [i < length after-days-counters]
    [
      set after-days-counters replace-item i after-days-counters (item i after-days-counters - 1)

      if item i after-days-counters = 0
        [
          let c-name item i after-days-swab-classrooms
          let students-list students with [ classroom = c-name and not quarantined? ]
          let infected-already-in-quarantine students with [ classroom = c-name and quarantined? ]

          swab-other-students students-list infected-already-in-quarantine c-name true

          if first-day-screening mod 5 != 0 and
             not (screening-policy = "1/4 of the class every week, in rotation, spread over two days of the week" and second-day-screening mod 5 = 0)
            [
              set after-days-swab-classrooms remove-item i after-days-swab-classrooms
              set after-days-counters remove-item i after-days-counters
              set i i - 1
            ]
        ]

      set i i + 1
    ]
end

to start-agents
  ask turtles with [ hidden? and not quarantined? and
                     ((staggered-group >= 0 and not item staggered-group end-day? and ticks >= move-time-in-ticks + start-day-time-in-ticks + (staggered-group * staggered-time-in-ticks)) or
                      (staggered-group < 0 and ticks >= move-time-in-ticks + start-day-time-in-ticks )) and classroom != "-" ]
    [
      set hidden? false

      ifelse temperature-measurement != "no measurement"
        [
          ifelse breed != janitors
            [ set-queue-and-temperature-time ]
            [ set temperature-already-measured? true ]
        ]
        [ setup-initial-targets ]
    ]
end

to set-queue-and-temperature-time
  set queue random 2 + 1

  ifelse queue = 1
    [
      set queue-position num-in-queue1
      set num-in-queue1 num-in-queue1 + 1
      setup-temperature-measurement-targets
    ]
    [
      set queue-position num-in-queue2
      set num-in-queue2 num-in-queue2 + 1
      setup-temperature-measurement-targets
    ]

  set temperature-time-in-ticks floor (abs random-normal temperature-measurement-mean-time-in-seconds temperature-measurement-std-in-seconds) / tick-duration-in-seconds
end

to move-queue
  ifelse queue = 1
    [
      set num-in-queue1 num-in-queue1 - 1

      ask turtles with [ not temperature-already-measured? and queue-position > 0 and queue = 1 ]
        [
          set queue-position queue-position - 1
          update-temperature-measurement-targets
          face first targets
        ]
    ]
    [
      set num-in-queue2 num-in-queue2 - 1

      ask turtles with [ not temperature-already-measured? and queue-position > 0 and queue = 2 ]
        [
          set queue-position queue-position - 1
          update-temperature-measurement-targets
          face first targets
        ]
    ]
end

to set-gym-hour [bool class-name]
  set gym-hour? bool
  ask students with [ classroom = class-name and not quarantined? ]
    [ set gym-hour? bool ]
end

to update-day-scheduling
  set day-scheduling item (day mod 5) personal-classrooms-scheduling
  let reduced-list remove "-" day-scheduling

  ifelse reduced-list != []
    [
      let next-classroom first reduced-list
      set floor-idx get-floor-by-classroom next-classroom
      set desk one-of patches with [ teacher-chair? and room-name = next-classroom ]
      set staggered-group [staggered-group] of (one-of students with [classroom = next-classroom ])

      set classroom first day-scheduling
      set day-scheduling but-first day-scheduling

      if classroom != "-"
        [
          if gym-teacher?
            [ set-gym-hour true classroom ]
        ]
    ]
    [ set classroom "-" ]
end

to move
  ask turtles with [ not hidden? ]
    [
      let start-move-group-time staggered-group * staggered-time-in-ticks + 1

      if ticks >= start-move-group-time
        [
          repeat movements-per-tick
            [
              ifelse patch-here != first targets
                [ fd 1 ]
                [
                  ifelse length targets > 1
                    [
                      if [stair?] of first targets
                        [
                          let f floor-idx

                          set xcor [pxcor] of one-of patches with [ stair? and floor-number = f ]
                          set ycor [pycor] of one-of patches with [ stair? and floor-number = f ]
                        ]

                      set targets but-first targets
                      face first targets
                    ]
                    [
                      if not hidden? and
                         first targets = patch-here and
                         outdoor? and
                         not entrance? and
                         temperature-already-measured?
                        [
                          set hidden? true
                          if temperature-measurement != "no measurement"
                            [ set temperature-already-measured? false ]

                          compute-mean-quanta-inhaled-per-room
                        ]
                    ]
                ]
            ]
        ]
    ]
end

;THIS FUNCTION NEED A REVIEW IF NEEDED!
;to measure-temperature
;  ask turtles with [ queue-position = 0 ]
;    [
;      if [ length targets ] of one-of janitors = 1 and measure-temperature-patch?
;        [
;          ifelse temperature-time-in-seconds > 0
;            [ set temperature-time-in-seconds temperature-time-in-seconds - 1 ]
;            [
;              set temperature-already-measured? true
;              set queue-position -1
;              move-queue
;              setup-after-measurement-targets
;
;              if symptomatic? and
;                 mild-symptom?
;                [
;                  set quarantined? true
;                  set num-infected num-infected - 1
;                  set num-infected-in-quarantine num-infected-in-quarantine + 1
;                  setup-after-measurement-targets
;
;                  if breed = teachers
;                    [
;                      ifelse supply-teachers != []
;                        [
;                          copy-teacher (first supply-teachers) who
;                          set supply-teachers but-first supply-teachers
;                        ]
;                        [ create-supply-teacher ]
;                    ]
;
;                  if breed = janitors
;                    [
;                      ifelse supply-janitors != []
;                        [
;                          copy-janitors (first supply-janitors) who
;                          set supply-janitors but-first supply-janitors
;                        ]
;                        [ create-supply-janitors ]
;                    ]
;                ]
;
;              set queue 0
;            ]
;        ]
;    ]
;end

to update-lessons
  let g 0

  repeat num-groups
    [
      if not item g end-day?
        [
          let start-group-lessons-time start-lessons-time-in-ticks + g * staggered-time-in-ticks

          if ticks > start-group-lessons-time and
             item g remain-time-for-lesson-in-ticks > 0
            [
              if item g remain-time-for-lesson-in-ticks = lesson-duration-in-ticks - interval-duration-in-ticks * 2
                [ ask teachers [ set update? false ] ]

              set remain-time-for-lesson-in-ticks replace-item g remain-time-for-lesson-in-ticks (item g remain-time-for-lesson-in-ticks - 1)
              move-gym g
            ]

          if item g remain-time-for-interval-in-ticks > 0
            [ set remain-time-for-interval-in-ticks replace-item g remain-time-for-interval-in-ticks (item g remain-time-for-interval-in-ticks - 1) ]

          let start-group-interval-time -1

          if start-intervals-time-in-ticks != []
            [ set start-group-interval-time (first start-intervals-time-in-ticks) + g * staggered-time-in-ticks ]

          if ticks = start-group-interval-time
            [
              if g = num-groups - 1
                [ set start-intervals-time-in-ticks but-first start-intervals-time-in-ticks ]

              set remain-time-for-interval-in-ticks replace-item g remain-time-for-interval-in-ticks interval-duration-in-ticks
              update-gym-teachers g
              update-students g
              go-somewhere g
            ]

          ifelse ticks = finish-lessons-time-in-ticks + g * staggered-time-in-ticks
            [
              update-students g
              end-school-day g
            ]
            [
              if item g remain-time-for-lesson-in-ticks = 0 and
                 item g remain-time-for-interval-in-ticks <= 0
                [
                  set remain-time-for-interval-in-ticks replace-item g remain-time-for-interval-in-ticks -1
                  update-teachers-classroom g
                  update-students g
                  go-gym g
                ]

              go-blackboard g
              go-bathroom g
              if not [quarantined?] of one-of principals
                [ go-principal g ]
            ]
        ]

      set g g + 1
    ]
end

to update-gym-teachers [g]
  ask teachers with [ gym-teacher? and gym? and staggered-group = g]
    [
      set-gym-hour false classroom

      set classroom "TR"
      go-to-teachers-room-from-gym
    ]
end

to update-students [g]
  set last-principal-time-in-ticks ticks

  ask students with [ staggered-group = g ]
    [
      if corridor? and
         length targets = 1
        [ return-from-corridor ]

      if not gym-hour? and
         gym?
        [ return-from-gym ]

      if member? patch-here patches with [ chair? and principal-office? ]
        [ return-from-principal ]
    ]
end

to go-somewhere [g]
  ask students with [ staggered-group = g and not bathroom? and not quarantined? ]
    [
      if random 1000 < prob-go-somewhere-during-interval * 1000
        [ go-to-corridor ]
    ]
end

to update-teachers-classroom [g]
  ask teachers with [staggered-group = g and not update? and not quarantined?]
    [
      let place-list list "-" "TR"
      let old-classroom classroom
      let old-desk desk
      let old-floor-idx floor-idx

      set classroom "-"

      if day-scheduling != []
        [
          set classroom first day-scheduling
          set day-scheduling but-first day-scheduling
        ]

      if classroom = "-" and
         not outdoor?
        [
          set classroom old-classroom
          set-targets-end-school
          set classroom "-"
          set floor-idx 1
        ]

      if classroom != "-" and
         classroom != old-classroom
        [
          set floor-idx get-floor-by-classroom classroom
          set desk one-of patches with [teacher-chair? and room-name = [classroom] of myself and not occupied?]

          ifelse classroom != "TR"
            [
              set staggered-group [staggered-group] of (one-of students with [classroom = [classroom] of myself ])

              if old-classroom = "TR"
                [ ask old-desk [ set occupied? false ] ]

              if gym-teacher?
                [
                  if not member? old-classroom place-list
                    [ set-gym-hour false old-classroom ]

                  set-gym-hour true classroom
                ]
            ]
            [ ask desk [ set occupied? true ] ]

          ifelse outdoor?
            [
              set hidden? false

              ifelse temperature-measurement != "no measurement"
                [ set-queue-and-temperature-time ]
                [
                  set old-floor-idx 1
                  set targets lput (one-of patches with [ entrance? and outdoor? ]) targets
                ]
            ]
            [
              ifelse gym?
                [ set targets lput one-of patches with [ entrance? and gym? ] targets ]
                [ set targets lput one-of patches with [ entrance? and room-name = old-classroom ] targets ]
            ]

          if temperature-already-measured?
            [
              if floor-idx != old-floor-idx
                [ set targets lput one-of patches with [ stair? and floor-number = old-floor-idx ] targets ]

              set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
              set targets lput desk targets

              face first targets
            ]
        ]

      set update? true
    ]

  set remain-time-for-lesson-in-ticks replace-item g remain-time-for-lesson-in-ticks lesson-duration-in-ticks
end

to go-blackboard [g]
  ask students with [ staggered-group = g and not quarantined? ]
    [
      let blackboard-patches patches with [ blackboard? and room-name = [classroom] of myself and not any? turtles-here ]

      if patch-here = desk
        [
          if random 10000 < (prob-go-blackboard / (60 / tick-duration-in-seconds)) * 10000
            [
              if count blackboard-patches = 2
                [ go-to-blackboard blackboard-patches ]
            ]
        ]

        if member? patch-here patches with [ blackboard? and room-name = [classroom] of myself ]
          [
            ifelse blackboard-time-in-ticks > 0
              [ set blackboard-time-in-ticks blackboard-time-in-ticks - 1 ]
              [ return-from-blackboard ]
          ]
    ]
end

to go-bathroom [g]
  ask turtles with [ (staggered-group = g or member? breed list principals janitors) and not quarantined? and temperature-already-measured? ]
    [
      let bathroom-name "TT"
      let bathroom-floor 1
      let teacher-condition true

      if breed = students
        [
          ifelse gym-hour?
            [
              set bathroom-name "1T"
              set bathroom-floor 1
            ]
            [
              set bathroom-name word floor-idx "T"
              set bathroom-floor floor-idx
            ]
        ]

      if breed = teachers
        [ set teacher-condition (room-name = "TR" and remove "-" day-scheduling != [] ) ]

      if toilet = []
        [
          if teacher-condition and random 10000 < (prob-go-bathroom / (60 / tick-duration-in-seconds)) * 10000
            [ go-to-bathroom bathroom-floor bathroom-name ]
        ]

      if toilet = "Wait" and
         bathroom?
        [
          let bathrooms-floor patches with [ toilet? and floor-number = bathroom-floor and not occupied? and room-name = bathroom-name ]

          if any? bathrooms-floor
            [ go-to-toilet bathrooms-floor ]
        ]

      if patch-here = toilet
        [
          ifelse toilet-time-in-ticks > 0
            [ set toilet-time-in-ticks toilet-time-in-ticks - 1 ]
            [ return-from-bathroom bathroom-floor bathroom-name ]
        ]
    ]
end

to go-principal [g]
  ask students with [ staggered-group = g and not quarantined? and temperature-already-measured? ]
    [
      let principal-patches patches with [ chair? and principal-office? and not any? turtles-here and not occupied? ]

      if patch-here = desk
        [
          if random 100000 < (prob-go-principal / (60 / tick-duration-in-seconds)) * 100000
            [
              if count principal-patches > 1
                [
                  go-to-principal g principal-patches
                  set last-principal-time-in-ticks ticks
                ]
            ]
        ]
    ]
end

to end-school-day [g]
  ask turtles with [ (staggered-group = g and not outdoor?) or (staggered-group = -1 and g = num-groups - 1)]
    [
      ifelse breed = teachers and
             remove "-" day-scheduling != []
        [ set staggered-group 1 ]
        [ set-targets-end-school ]
    ]

  set end-day? replace-item g end-day? true

  if g = num-groups - 1
    [
      set start-day-time-in-ticks ticks + offset-between-days-in-ticks
      setup-day-school-variables
      ask turtles with [ breed != janitors ]
        [ set move-time-in-ticks random offset-between-entrance-and-start-lessons-in-ticks + 1 ]

      ask patches with [ occupied? ]
        [ set occupied? false ]
    ]
end

to accumulate-aerosol-all-rooms
  foreach rooms-aerosol
    [
      room -> if any? patches with [ room-name = room ]
                [ accumulate-aerosol room ]
    ]
end

to accumulate-aerosol [room]
  let people count turtles with [ room-name = room ]
  let infected-student count turtles with [ not vaccinated? and breed = students and infected? and room-name = room ]
  let infected-teacher count turtles with [ not vaccinated? and breed = teachers and infected? and room-name = room ]
  let infected-principal count turtles with [ not vaccinated? and breed = principals and infected? and room-name = room ]
  let infected-janitors count turtles with [ not vaccinated? and breed = janitors and infected? and room-name = room ]
  let infected-student-vaccinated count turtles with [ vaccinated? and breed = students and infected? and room-name = room ]
  let infected-teacher-vaccinated count turtles with [ vaccinated? and breed = teachers and infected? and room-name = room ]
  let infected-principal-vaccinated count turtles with [ vaccinated? and breed = principals and infected? and room-name = room ]
  let infected-janitors-vaccinated count turtles with [ vaccinated? and breed = janitors and infected? and room-name = room ]
  let infectious-vaccinated-factor-students 0
  let infectious-vaccinated-factor-teachers 0
  let infectious-vaccinated-factor-principals 0
  let infectious-vaccinated-factor-janitors 0
  let has-people 0
  let dt tick-duration-in-seconds
  let volume classroom-volume

  if vaccine-efficacy < 1
    [
      if vaccinated-students?
        [ set infectious-vaccinated-factor-students infectious-vaccinated-factor ]

      if vaccinated-teachers?
        [ set infectious-vaccinated-factor-teachers infectious-vaccinated-factor ]

      if vaccinated-principals?
        [ set infectious-vaccinated-factor-principals infectious-vaccinated-factor ]

      if vaccinated-janitors?
        [ set infectious-vaccinated-factor-janitors infectious-vaccinated-factor ]
    ]

  let base-n-r-students (activity-type-students * ngen-base) / (10 ^ vl)
  let base-n-r-students-in-gym (activity-type-students-in-gym * ngen-base) / (10 ^ vl)
  let base-n-r-teachers (activity-type-teachers * ngen-base) / (10 ^ vl)
  let base-n-r-teachers-in-classroom (activity-type-teachers-in-classroom * ngen-base) / (10 ^ vl)
  let base-n-r-principals (activity-type-principals * ngen-base) / (10 ^ vl)
  let base-n-r-janitors (activity-type-janitors * ngen-base) / (10 ^ vl)

  let base-n-r-students-vaccinated (activity-type-students * ngen-base * infectious-vaccinated-factor-students) / (10 ^ vl)
  let base-n-r-students-in-gym-vaccinated (activity-type-students-in-gym * ngen-base * infectious-vaccinated-factor-students) / (10 ^ vl)
  let base-n-r-teachers-vaccinated (activity-type-teachers * ngen-base * infectious-vaccinated-factor-teachers) / (10 ^ vl)
  let base-n-r-teachers-in-classroom-vaccinated (activity-type-teachers-in-classroom * ngen-base * infectious-vaccinated-factor-teachers) / (10 ^ vl)
  let base-n-r-principals-vaccinated (activity-type-principals * ngen-base * infectious-vaccinated-factor-principals) / (10 ^ vl)
  let base-n-r-janitors-vaccinated (activity-type-janitors * ngen-base * infectious-vaccinated-factor-janitors) / (10 ^ vl)

  let n-r-students (10 ^ vl) * base-n-r-students * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-students-in-gym (10 ^ vl) * base-n-r-students-in-gym * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-teachers (10 ^ vl) * base-n-r-teachers * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-teachers-in-classroom (10 ^ vl) * base-n-r-teachers-in-classroom * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-principals (10 ^ vl) * base-n-r-principals * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-janitors (10 ^ vl) * base-n-r-janitors * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)

  let n-r-students-vaccinated (10 ^ vl) * base-n-r-students-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-students-in-gym-vaccinated (10 ^ vl) * base-n-r-students-in-gym-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-teachers-vaccinated (10 ^ vl) * base-n-r-teachers-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-teachers-in-classroom-vaccinated (10 ^ vl) * base-n-r-teachers-in-classroom-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-principals-vaccinated (10 ^ vl) * base-n-r-principals-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)
  let n-r-janitors-vaccinated (10 ^ vl) * base-n-r-janitors-vaccinated * (1 - exhalation-mask-efficiency * fraction-of-population-wearing-mask)

  let total-n-r n-r-students * infected-student + n-r-students-vaccinated * infected-student-vaccinated +
      n-r-teachers-in-classroom * infected-teacher + n-r-teachers-in-classroom-vaccinated * infected-teacher-vaccinated +
      n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
      n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated

  if room = "TR"
    [
      set volume teachers-room-volume
      set total-n-r n-r-students * infected-student + n-r-students-vaccinated * infected-student-vaccinated +
          n-r-teachers * infected-teacher + n-r-teachers-vaccinated * infected-teacher-vaccinated +
          n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
          n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated
    ]

  if room = "PO"
    [
      set volume principal-office-volume
      set total-n-r n-r-students * infected-student + n-r-students-vaccinated * infected-student-vaccinated +
          n-r-teachers * infected-teacher + n-r-teachers-vaccinated * infected-teacher-vaccinated +
          n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
          n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated
    ]

  if room = "MR"
    [
      set volume measurement-room-volume
      set total-n-r n-r-students * infected-student + n-r-students-vaccinated * infected-student-vaccinated +
          n-r-teachers * infected-teacher + n-r-teachers-vaccinated * infected-teacher-vaccinated +
          n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
          n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated
    ]

  if room = "G"
    [
      set volume gym-volume
      set total-n-r n-r-students-in-gym * infected-student + n-r-students-in-gym-vaccinated * infected-student-vaccinated +
          n-r-teachers * infected-teacher + n-r-teachers-vaccinated * infected-teacher-vaccinated +
          n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
          n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated
    ]

  if last room = "T"
    [
      set volume bathroom-volume
      set total-n-r n-r-students * infected-student + n-r-students-vaccinated * infected-student-vaccinated +
          n-r-teachers * infected-teacher + n-r-teachers-vaccinated * infected-teacher-vaccinated +
          n-r-principals * infected-principal + n-r-principals-vaccinated * infected-principal-vaccinated +
          n-r-janitors * infected-janitors + n-r-janitors-vaccinated * infected-janitors-vaccinated
    ]

  if people > 0
    [ set has-people 1 ]

  ask patches with [ entrance? and room-name = room ]
    [
      set cumulative-quanta-concentration (has-people * total-n-r) / volume / total-first-order-loss-rate +
                                          (cumulative-quanta-concentration - ((has-people * total-n-r) / volume / total-first-order-loss-rate)) * exp(- total-first-order-loss-rate * dt)

      ask turtles with [ room-name = room and susceptible? and not entrance? ]
        [
          let inhalation-rate inhalation-rate-students

          if vaccinated?
            [ set inhalation-rate inhalation-rate-students * infectious-vaccinated-factor-students ]

          if room = "G"
            [
              ifelse vaccinated?
                [ set inhalation-rate inhalation-rate-students-in-gym * infectious-vaccinated-factor-students ]
                [ set inhalation-rate inhalation-rate-students-in-gym ]
            ]

          if breed = teachers
            [
              ifelse classroom?
                [ set inhalation-rate inhalation-rate-teachers-in-classroom ]
                [ set inhalation-rate inhalation-rate-teachers ]

              if vaccinated?
                [ set inhalation-rate inhalation-rate * infectious-vaccinated-factor-teachers ]
            ]

          if breed = principals
            [
              ifelse vaccinated?
                [ set inhalation-rate inhalation-rate-principals * infectious-vaccinated-factor-principals ]
                [ set inhalation-rate inhalation-rate-principals ]
            ]

          if breed = janitors
            [
              ifelse vaccinated?
                [ set inhalation-rate inhalation-rate-janitors * infectious-vaccinated-factor-janitors ]
                [ set inhalation-rate inhalation-rate-janitors ]
            ]

          if [classroom?] of patch-here
            [ set cumulative-quanta-inhaled-in-classroom cumulative-quanta-inhaled-in-classroom + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          if room = "TR"
            [ set cumulative-quanta-inhaled-in-teachers-room cumulative-quanta-inhaled-in-teachers-room + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          if room = "PO"
            [ set cumulative-quanta-inhaled-in-principal-office cumulative-quanta-inhaled-in-principal-office + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          if room = "MR"
            [ set cumulative-quanta-inhaled-in-measurement-room cumulative-quanta-inhaled-in-measurement-room + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          if room = "G"
            [ set cumulative-quanta-inhaled-in-gym cumulative-quanta-inhaled-in-gym + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          if last room = "T"
            [ set cumulative-quanta-inhaled-in-bathroom cumulative-quanta-inhaled-in-bathroom + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself ]

          set cumulative-quanta-inhaled cumulative-quanta-inhaled + has-people * inhalation-rate * dt * [cumulative-quanta-concentration] of myself
      ]
    ]
end

to infect-aerosol
  ask turtles with [ hidden? and cumulative-quanta-inhaled != 0 and susceptible? ]
    [
      let pi-agent 1 - exp(- cumulative-quanta-inhaled / risk-const)

      if random 1000000 < pi-agent * 1000000
        [ get-infected false ]

      set cumulative-quanta-inhaled 0
    ]
end

to compute-mean-quanta-inhaled-per-room
  let index 1

  if breed = teachers
    [ set index 2 ]

  if breed = principals
    [ set index 3 ]

  if breed = janitors
    [ set index 4 ]

  set num-active-agents replace-item 0 num-active-agents (item 0 num-active-agents + 1)
  set num-active-agents replace-item index num-active-agents (item index num-active-agents + 1)
  set mean-quanta-inhaled replace-item 0 mean-quanta-inhaled (item 0 mean-quanta-inhaled + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled - item 0 mean-quanta-inhaled))
  set mean-quanta-inhaled replace-item index mean-quanta-inhaled (item index mean-quanta-inhaled + (1 / item index num-active-agents) * (cumulative-quanta-inhaled - item index mean-quanta-inhaled))
  set mean-quanta-inhaled-in-classroom replace-item 0 mean-quanta-inhaled-in-classroom (item 0 mean-quanta-inhaled-in-classroom + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-classroom - item 0 mean-quanta-inhaled-in-classroom))
  set mean-quanta-inhaled-in-classroom replace-item index mean-quanta-inhaled-in-classroom (item index mean-quanta-inhaled-in-classroom + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-classroom - item index mean-quanta-inhaled-in-classroom))
  set mean-quanta-inhaled-in-gym replace-item 0 mean-quanta-inhaled-in-gym (item 0 mean-quanta-inhaled-in-gym + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-gym - item 0 mean-quanta-inhaled-in-gym))
  set mean-quanta-inhaled-in-gym replace-item index mean-quanta-inhaled-in-gym (item index mean-quanta-inhaled-in-gym + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-gym - item index mean-quanta-inhaled-in-gym))
  set mean-quanta-inhaled-in-measurement-room replace-item 0 mean-quanta-inhaled-in-measurement-room (item 0 mean-quanta-inhaled-in-measurement-room + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-measurement-room - item 0 mean-quanta-inhaled-in-measurement-room))
  set mean-quanta-inhaled-in-measurement-room replace-item index mean-quanta-inhaled-in-measurement-room (item index mean-quanta-inhaled-in-measurement-room + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-measurement-room - item index mean-quanta-inhaled-in-measurement-room))
  set mean-quanta-inhaled-in-principal-office replace-item 0 mean-quanta-inhaled-in-principal-office (item 0 mean-quanta-inhaled-in-principal-office + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-principal-office - item 0 mean-quanta-inhaled-in-principal-office))
  set mean-quanta-inhaled-in-principal-office replace-item index mean-quanta-inhaled-in-principal-office (item index mean-quanta-inhaled-in-principal-office + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-principal-office - item index mean-quanta-inhaled-in-principal-office))
  set mean-quanta-inhaled-in-teachers-room replace-item 0 mean-quanta-inhaled-in-teachers-room (item 0 mean-quanta-inhaled-in-teachers-room + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-teachers-room - item 0 mean-quanta-inhaled-in-teachers-room))
  set mean-quanta-inhaled-in-teachers-room replace-item index mean-quanta-inhaled-in-teachers-room (item index mean-quanta-inhaled-in-teachers-room + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-teachers-room - item index mean-quanta-inhaled-in-teachers-room))
  set mean-quanta-inhaled-in-bathroom replace-item 0 mean-quanta-inhaled-in-bathroom (item 0 mean-quanta-inhaled-in-bathroom + (1 / item 0 num-active-agents) * (cumulative-quanta-inhaled-in-bathroom - item 0 mean-quanta-inhaled-in-bathroom))
  set mean-quanta-inhaled-in-bathroom replace-item index mean-quanta-inhaled-in-bathroom (item index mean-quanta-inhaled-in-bathroom + (1 / item index num-active-agents) * (cumulative-quanta-inhaled-in-bathroom - item index mean-quanta-inhaled-in-bathroom))
end

to accumulate-contact-with-infected
  ask turtles with [ not hidden? and infected? and not quarantined? ]
    [
      let who-infected who

      ask (turtles-on neighbors) with [ not hidden? and susceptible? and room-name = [room-name] of myself ]
      [
        let contact-value matrix:get contact-time-with-infected-matrix-in-ticks who who-infected

        ;Different cases: not vaccinated-not vaccinated, not vaccinated-vaccinated (or vaccinated-not vaccinated), vaccinated-vaccinated
        ifelse [vaccinated?] of myself or
               vaccinated?
          [ matrix:set contact-time-with-infected-matrix-in-ticks who who-infected ((contact-value + 1) * infectious-vaccinated-factor) ]
          [ matrix:set contact-time-with-infected-matrix-in-ticks who who-infected (contact-value + 1) ]
      ]
    ]
end

to infect-with-contact
  ask turtles with [ hidden? and sum matrix:get-row contact-time-with-infected-matrix-in-ticks who != 0 and susceptible? ]
    [
      let contact-time-in-min ((sum matrix:get-row contact-time-with-infected-matrix-in-ticks who) * tick-duration-in-seconds) / 60

      let pi-agent contamination-risk * (contact-time-in-min / contact-space-volume)

      if random 1000 < pi-agent * 1000
        [ get-infected false ]

      matrix:set-row contact-time-with-infected-matrix-in-ticks who (n-values (num-agents * 2) [0])
    ]
end

to verify-contact
  ask turtles with [ not hidden? and not quarantined? ]
    [
      let who-ego who
      let infected-ego? infected?

      ask (turtles-on neighbors) with [ not hidden? and room-name = [room-name] of myself ]
        [
          let contact-value matrix:get contact-time-matrix-in-ticks who who-ego
          matrix:set contact-time-matrix-in-ticks who who-ego (contact-value + 1)

          if matrix:get is-in-contact-matrix? who who-ego = 0
            [
              matrix:set is-in-contact-matrix? who who-ego 1

              let number-of-contact matrix:get number-of-contact-matrix who who-ego
              matrix:set number-of-contact-matrix who who-ego (number-of-contact + 1)
            ]

          if infected-ego? and
             susceptible?
            [
              let contact-infected-value matrix:get contact-time-with-infected-matrix-in-ticks who who-ego

              ifelse [vaccinated?] of myself or
               vaccinated?
                [ matrix:set contact-time-with-infected-matrix-in-ticks who who-ego ((contact-infected-value + 1) * infectious-vaccinated-factor) ]
                [ matrix:set contact-time-with-infected-matrix-in-ticks who who-ego (contact-infected-value + 1) ]
            ]
        ]

      ask turtles with [ not member? self [turtles-on neighbors] of myself ]
        [ matrix:set is-in-contact-matrix? who who-ego 0 ]
     ]
end

to put-classroom-in-quarantine [c-name quarantine-ext-1? quarantine-ext-2?]
  ask students with [ classroom = c-name and not quarantined? ]
    [
      set quarantined? true
      set quarantined-external-1? quarantine-ext-1?
      set quarantined-external-2? quarantine-ext-2?

      update-put-in-quarantine-variables

      set remain-quarantine-days num-of-quarantine-days

      while [remain-incubation-days >= remain-quarantine-days]
        [ set remain-incubation-days floor (remain-incubation-days / 2) ]
    ]

  set classrooms-in-quarantine lput c-name classrooms-in-quarantine
end

to put-student-in-quarantine [quarantine-ext-1? quarantine-ext-2?]
  set quarantined? true
  set quarantined-external-1? quarantine-ext-1?
  set quarantined-external-2? quarantine-ext-2?

  update-put-in-quarantine-variables

  set remain-quarantine-days num-of-quarantine-days

  while [remain-incubation-days >= remain-quarantine-days]
    [ set remain-incubation-days floor (remain-incubation-days / 2) ]
end

to update-put-in-quarantine-variables
  if susceptible?
    [
      ifelse vaccinated?
      [
        set num-vaccinated-susceptible num-vaccinated-susceptible - 1

        ifelse quarantined-external-1?
          [ set num-vaccinated-susceptible-in-quarantine-external-1 num-vaccinated-susceptible-in-quarantine-external-1 + 1 ]
          [
            ifelse quarantined-external-2?
              [ set num-vaccinated-susceptible-in-quarantine-external-2 num-vaccinated-susceptible-in-quarantine-external-2 + 1 ]
              [ set num-vaccinated-susceptible-in-quarantine num-vaccinated-susceptible-in-quarantine + 1 ]
          ]
      ]
      [
        set num-susceptible num-susceptible - 1

        ifelse quarantined-external-1?
          [ set num-susceptible-in-quarantine-external-1 num-susceptible-in-quarantine-external-1 + 1 ]
          [
            ifelse quarantined-external-2?
              [ set num-susceptible-in-quarantine-external-2 num-susceptible-in-quarantine-external-2 + 1 ]
              [ set num-susceptible-in-quarantine num-susceptible-in-quarantine + 1 ]
          ]
      ]
    ]

  if exposed?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-exposed num-vaccinated-exposed - 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-exposed-in-quarantine-external-1 num-vaccinated-exposed-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-exposed-in-quarantine-external-2 num-vaccinated-exposed-in-quarantine-external-2 + 1 ]
               [ set num-vaccinated-exposed-in-quarantine num-vaccinated-exposed-in-quarantine + 1 ]
           ]
        ]
        [
          set num-exposed num-exposed - 1

          ifelse quarantined-external-1?
           [ set num-exposed-in-quarantine-external-1 num-exposed-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-exposed-in-quarantine-external-2 num-exposed-in-quarantine-external-2 + 1 ]
               [ set num-exposed-in-quarantine num-exposed-in-quarantine + 1 ]
           ]
        ]
    ]

  if infected?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-infected num-vaccinated-infected - 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-infected-in-quarantine-external-1 num-vaccinated-infected-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-infected-in-quarantine-external-2 num-vaccinated-infected-in-quarantine-external-2 + 1 ]
               [ set num-vaccinated-infected-in-quarantine num-vaccinated-infected-in-quarantine + 1 ]
           ]
        ]
        [
          set num-infected num-infected - 1

          ifelse quarantined-external-1?
           [ set num-infected-in-quarantine-external-1 num-infected-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-infected-in-quarantine-external-2 num-infected-in-quarantine-external-2 + 1 ]
               [ set num-infected-in-quarantine num-infected-in-quarantine + 1 ]
           ]
        ]
    ]

  if removed?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-removed num-vaccinated-removed - 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-removed-in-quarantine-external-1 num-vaccinated-removed-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-removed-in-quarantine-external-2 num-vaccinated-removed-in-quarantine-external-2 + 1 ]
               [ set num-vaccinated-removed-in-quarantine num-vaccinated-removed-in-quarantine + 1 ]
           ]
        ]
        [
          set num-removed num-removed - 1

          ifelse quarantined-external-1?
           [ set num-removed-in-quarantine-external-1 num-removed-in-quarantine-external-1 + 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-removed-in-quarantine-external-2 num-removed-in-quarantine-external-2 + 1 ]
               [ set num-removed-in-quarantine num-removed-in-quarantine + 1 ]
           ]
        ]
    ]
end

to get-infected [init-infected?]
  ifelse quarantined?
    [
      ifelse vaccinated?
        [
          ifelse quarantined-external-1?
            [ set num-vaccinated-susceptible-in-quarantine-external-1 num-vaccinated-susceptible-in-quarantine-external-1 - 1 ]
            [
              ifelse quarantined-external-2?
                [ set num-vaccinated-susceptible-in-quarantine-external-2 num-vaccinated-susceptible-in-quarantine-external-2 - 1 ]
                [ set num-vaccinated-susceptible-in-quarantine num-vaccinated-susceptible-in-quarantine - 1 ]
            ]
        ]
        [
          ifelse quarantined-external-1?
            [ set num-susceptible-in-quarantine-external-1 num-susceptible-in-quarantine-external-1 - 1 ]
            [
              ifelse quarantined-external-2?
                [ set num-susceptible-in-quarantine-external-2 num-susceptible-in-quarantine-external-2 - 1 ]
                [ set num-susceptible-in-quarantine num-susceptible-in-quarantine - 1 ]
            ]
        ]
    ]
    [
      ifelse vaccinated?
        [ set num-vaccinated-susceptible num-vaccinated-susceptible - 1 ]
        [ set num-susceptible num-susceptible - 1 ]
    ]

  ifelse init-infected?
    [
      ifelse vaccinated?
        [ set num-vaccinated-infected num-vaccinated-infected + 1 ]
        [ set num-infected num-infected + 1 ]

      set susceptible? false
      set infected? true

      if not vaccinated?
        [ set color red ]
    ]
    [
      ifelse quarantined?
        [
          ifelse vaccinated?
           [
             ifelse quarantined-external-1?
                [ set num-vaccinated-exposed-in-quarantine-external-1 num-vaccinated-exposed-in-quarantine-external-1 + 1 ]
                [
                  ifelse quarantined-external-2?
                    [ set num-vaccinated-exposed-in-quarantine-external-2 num-vaccinated-exposed-in-quarantine-external-2 + 1 ]
                    [ set num-vaccinated-exposed-in-quarantine num-vaccinated-exposed-in-quarantine + 1 ]
                ]
           ]
           [
             ifelse quarantined-external-1?
                [ set num-exposed-in-quarantine-external-1 num-exposed-in-quarantine-external-1 + 1 ]
                [
                  ifelse quarantined-external-2?
                    [ set num-exposed-in-quarantine-external-2 num-exposed-in-quarantine-external-2 + 1 ]
                    [ set num-exposed-in-quarantine num-exposed-in-quarantine + 1 ]
                ]
           ]
        ]
        [
          ifelse vaccinated?
            [ set num-vaccinated-exposed num-vaccinated-exposed + 1 ]
            [ set num-exposed num-exposed + 1 ]
        ]

      set remain-incubation-days ceiling random-exponential mean-incubation-duration-in-days
      set susceptible? false
      set exposed? true

      if not vaccinated?
        [ set color blue ]
    ]

  set remain-infected-days ceiling random-exponential mean-infection-duration-in-days
end

to update-infected
  ifelse exposed?
    [
      set remain-incubation-days remain-incubation-days - 1

      if remain-incubation-days = 0
        [
          set exposed? false
          set infected? true

          if not vaccinated?
            [ set color red ]

          ifelse quarantined?
            [
              ifelse vaccinated?
                [
                  ifelse quarantined-external-1?
                    [
                      set num-vaccinated-exposed-in-quarantine-external-1 num-vaccinated-exposed-in-quarantine-external-1 - 1
                      set num-vaccinated-infected-in-quarantine-external-1 num-vaccinated-infected-in-quarantine-external-1 + 1
                    ]
                    [
                      ifelse quarantined-external-2?
                        [
                          set num-vaccinated-exposed-in-quarantine-external-2 num-vaccinated-exposed-in-quarantine-external-2 - 1
                          set num-vaccinated-infected-in-quarantine-external-2 num-vaccinated-infected-in-quarantine-external-2 + 1
                        ]
                        [
                          set num-vaccinated-exposed-in-quarantine num-vaccinated-exposed-in-quarantine - 1
                          set num-vaccinated-infected-in-quarantine num-vaccinated-infected-in-quarantine + 1
                        ]
                    ]
                ]
                [
                  ifelse quarantined-external-1?
                    [
                      set num-exposed-in-quarantine-external-1 num-exposed-in-quarantine-external-1 - 1
                      set num-infected-in-quarantine-external-1 num-infected-in-quarantine-external-1 + 1
                    ]
                    [
                      ifelse quarantined-external-2?
                        [
                          set num-exposed-in-quarantine-external-2 num-exposed-in-quarantine-external-2 - 1
                          set num-infected-in-quarantine-external-2 num-infected-in-quarantine-external-2 + 1
                        ]
                        [
                          set num-exposed-in-quarantine num-exposed-in-quarantine - 1
                          set num-infected-in-quarantine num-infected-in-quarantine + 1
                        ]
                    ]
                ]
            ]
            [
              ifelse vaccinated?
                [
                  set num-vaccinated-exposed num-vaccinated-exposed - 1
                  set num-vaccinated-infected num-vaccinated-infected + 1
                ]
                [
                  set num-exposed num-exposed - 1
                  set num-infected num-infected + 1
                ]
            ]
        ]
    ]
    [ get-removed ]
end

to get-removed
  set remain-infected-days remain-infected-days - 1

  if remain-infected-days = 0
    [
      ifelse quarantined?
        [
          ifelse vaccinated?
            [
              ifelse quarantined-external-1?
                [
                  set num-vaccinated-infected-in-quarantine-external-1 num-vaccinated-infected-in-quarantine-external-1 - 1
                  set num-vaccinated-removed-in-quarantine-external-1 num-vaccinated-removed-in-quarantine-external-1 + 1
                ]
                [
                  ifelse quarantined-external-2?
                    [
                      set num-vaccinated-infected-in-quarantine-external-2 num-vaccinated-infected-in-quarantine-external-2 - 1
                      set num-vaccinated-removed-in-quarantine-external-2 num-vaccinated-removed-in-quarantine-external-2 + 1
                    ]
                    [
                      set num-vaccinated-infected-in-quarantine num-vaccinated-infected-in-quarantine - 1
                      set num-vaccinated-removed-in-quarantine num-vaccinated-removed-in-quarantine + 1
                    ]
                ]
            ]
            [
              ifelse quarantined-external-1?
                [
                  set num-infected-in-quarantine-external-1 num-infected-in-quarantine-external-1 - 1
                  set num-removed-in-quarantine-external-1 num-removed-in-quarantine-external-1 + 1
                ]
                [
                  ifelse quarantined-external-2?
                    [
                      set num-infected-in-quarantine-external-2 num-infected-in-quarantine-external-2 - 1
                      set num-removed-in-quarantine-external-2 num-removed-in-quarantine-external-2 + 1
                    ]
                    [
                      set num-infected-in-quarantine num-infected-in-quarantine - 1
                      set num-removed-in-quarantine num-removed-in-quarantine + 1
                    ]
                ]
            ]
        ]
        [
          ifelse vaccinated?
            [
              set num-vaccinated-infected num-vaccinated-infected - 1
              set num-vaccinated-removed num-vaccinated-removed + 1
            ]
            [
              set num-infected num-infected - 1
              set num-removed num-removed + 1
            ]
        ]

      if not vaccinated?
        [ set color black ]

      set infected? false
      set removed? true
    ]
end

to remove-from-quarantine
  if susceptible?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-susceptible num-vaccinated-susceptible + 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-susceptible-in-quarantine-external-1 num-vaccinated-susceptible-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-susceptible-in-quarantine-external-2 num-vaccinated-susceptible-in-quarantine-external-2 - 1 ]
               [ set num-vaccinated-susceptible-in-quarantine num-vaccinated-susceptible-in-quarantine - 1 ]
           ]
        ]
        [
          set num-susceptible num-susceptible + 1

          ifelse quarantined-external-1?
           [ set num-susceptible-in-quarantine-external-1 num-susceptible-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-susceptible-in-quarantine-external-2 num-susceptible-in-quarantine-external-2 - 1 ]
               [ set num-susceptible-in-quarantine num-susceptible-in-quarantine - 1 ]
           ]
        ]
    ]

  if exposed?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-exposed num-vaccinated-exposed + 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-exposed-in-quarantine-external-1 num-vaccinated-exposed-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-exposed-in-quarantine-external-2 num-vaccinated-exposed-in-quarantine-external-2 - 1 ]
               [ set num-vaccinated-exposed-in-quarantine num-vaccinated-exposed-in-quarantine - 1 ]
           ]
        ]
        [
          set num-exposed num-exposed + 1

          ifelse quarantined-external-1?
           [ set num-exposed-in-quarantine-external-1 num-exposed-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-exposed-in-quarantine-external-2 num-exposed-in-quarantine-external-2 - 1 ]
               [ set num-exposed-in-quarantine num-exposed-in-quarantine - 1 ]
           ]
        ]
    ]

  if infected?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-infected num-vaccinated-infected + 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-infected-in-quarantine-external-1 num-vaccinated-infected-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-infected-in-quarantine-external-2 num-vaccinated-infected-in-quarantine-external-2 - 1 ]
               [ set num-vaccinated-infected-in-quarantine num-vaccinated-infected-in-quarantine - 1 ]
           ]
        ]
        [
          set num-infected num-infected + 1

          ifelse quarantined-external-1?
           [ set num-infected-in-quarantine-external-1 num-infected-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-infected-in-quarantine-external-2 num-infected-in-quarantine-external-2 - 1 ]
               [ set num-infected-in-quarantine num-infected-in-quarantine - 1 ]
           ]
        ]
    ]

  if removed?
    [
      ifelse vaccinated?
        [
          set num-vaccinated-removed num-vaccinated-removed + 1

          ifelse quarantined-external-1?
           [ set num-vaccinated-removed-in-quarantine-external-1 num-vaccinated-removed-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-vaccinated-removed-in-quarantine-external-2 num-vaccinated-removed-in-quarantine-external-2 - 1 ]
               [ set num-vaccinated-removed-in-quarantine num-vaccinated-removed-in-quarantine - 1 ]
           ]
        ]
        [
          set num-removed num-removed + 1

          ifelse quarantined-external-1?
           [ set num-removed-in-quarantine-external-1 num-removed-in-quarantine-external-1 - 1 ]
           [
             ifelse quarantined-external-2?
               [ set num-removed-in-quarantine-external-2 num-removed-in-quarantine-external-2 - 1 ]
               [ set num-removed-in-quarantine num-removed-in-quarantine - 1 ]
           ]
        ]
    ]

  if remain-infected-days > 0
    [ set remain-infected-days 1 ]

  set quarantined? false
  set quarantined-external-1? false
  set quarantined-external-2? false

  if breed = teachers
    [
      ask teachers with [supply? and who != [who] of myself and teacher-idx = [teacher-idx] of myself ]
        [
          reset-supply-teacher
          if not member? who supply-teachers
            [ set supply-teachers lput who supply-teachers ]
        ]
    ]

  if not empty? classrooms-in-quarantine and
     position classroom classrooms-in-quarantine != false
    [ set classrooms-in-quarantine remove classroom classrooms-in-quarantine ]
end

to outside-contagion
  let prob-outside-contagion prob-outside-contagion-young

  if age-group = "Regular"
    [ set prob-outside-contagion prob-outside-contagion-regular ]

  if age-group = "Old"
    [ set prob-outside-contagion prob-outside-contagion-old ]

  if vaccinated? and
     vaccine-efficacy < 1
    [ set prob-outside-contagion prob-outside-contagion * infectious-vaccinated-factor ]

  if random 10000 < prob-outside-contagion * 10000
    [
      get-infected false
      set num-infected-outside num-infected-outside + 1
    ]
end



;Move functions
to setup-temperature-measurement-targets
  let queue-patch no-patches

  ifelse queue = 1
    [ set queue-patch item queue-position patches-queue1 ]
    [ set queue-patch item queue-position patches-queue2 ]

  if [measurement-room?] of queue-patch
    [
      set targets lput (one-of patches with [ entrance? and outdoor? ]) []
      set targets lput one-of patches with [ entrance? and plabel = word "M" [queue] of myself ] targets
    ]

  if [corridor?] of queue-patch
    [ set targets lput (one-of patches with [ entrance? and outdoor? ]) [] ]

  set targets lput queue-patch targets
  face first targets
end

to update-temperature-measurement-targets
  let queue-patch no-patches

  ifelse queue = 1
    [ set queue-patch item queue-position patches-queue1 ]
    [ set queue-patch item queue-position patches-queue2 ]

  set targets lput queue-patch but-last targets
  face first targets
end

to setup-after-measurement-targets
  ifelse quarantined?
    [
      set targets lput one-of patches with [ exit? and plabel = word "M" [queue] of myself ] targets

      let next-classroom classroom

      if breed = teachers
        [ set next-classroom first item (day mod 5) personal-classrooms-scheduling ]

      let staggered-condition (member? breed list teachers students and next-classroom != "-")

      ifelse staggered-admissions? and
             staggered-condition
        [
          let init-patch no-patches

          ask one-of patches with [ outdoor? and room-name = next-classroom ]
            [ set init-patch one-of patches in-radius 5 ]

          set targets lput init-patch targets
        ]
        [ set targets lput (one-of patches with [ not entrance? and outdoor? ]) targets ]
    ]
    [
      set targets lput one-of patches with [ exit? and plabel = word "M" [queue] of myself ] targets

      if floor-idx > 1
        [ set targets lput (one-of patches with [ stair? and floor-number = 1 ]) targets ]

      set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
      set targets lput desk targets

      if gym-hour? or
         (breed = teachers and gym-teacher?)
        [ go-gym-single-agent ]
    ]

  face first targets
end

to setup-initial-targets
  set targets lput (one-of patches with [ entrance? and outdoor? ]) []

  if floor-idx > 1
    [ set targets lput (one-of patches with [ stair? and floor-number = 1 ]) targets ]

  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
  set targets lput desk targets

  if gym-hour? or
     (breed = teachers and gym-teacher?)
    [ go-gym-single-agent ]

  face first targets
end

to go-gym [g]
  ask turtles with [ staggered-group = g and gym-hour? and not gym? and not bathroom? and not quarantined? and temperature-already-measured? ]
    [ go-gym-single-agent ]
end

to go-gym-single-agent
  set toilet-time-in-ticks 0
  set toilet []
  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets

  if floor-idx > 1
    [ set targets lput one-of patches with [ stair? and floor-number = [floor-idx] of myself ] targets ]

  set floor-idx 1

  set targets lput one-of patches with [ entrance? and gym? ] targets

  ifelse breed = teachers
    [ set targets lput one-of patches with [ gym? and [ not gym? ] of patch-at -1 0 ] targets ]
    [ set targets lput one-of patches with [ gym? ] targets ]

  face first targets
end

to move-gym [g]
  ask students with [ gym-hour? and toilet = [] and staggered-group = g and patch-here = first targets and temperature-already-measured? and not quarantined? ]
    [
      set targets lput one-of patches with [ gym? ] targets
      face first targets
    ]
end

to go-to-teachers-room-from-gym
  set targets lput one-of patches with [ entrance? and gym? ] targets
  set targets lput one-of patches with [ entrance? and teachers-room? ] targets
  set targets lput one-of patches with [ teachers-room? and teacher-chair? and count turtles-here = 0 ] targets
  face first targets
end

to return-from-gym
  set targets lput one-of patches with [ entrance? and gym? ] targets
  set floor-idx get-floor-by-classroom classroom
  if floor-idx > 1
    [ set targets lput one-of patches with [ stair? and floor-number = 1 ] targets ]
  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
  set targets lput desk targets
  face first targets
end

to go-to-corridor
  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets

  ifelse interval-in-front-of-classroom?
    [ set targets lput one-of patches with [ corridor? and in-front-of = [classroom] of myself ] targets ]
    [ set targets lput one-of patches with [ corridor? and floor-number = [floor-idx] of myself] targets ]

  face first targets
end

to return-from-corridor
  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
  set targets lput desk targets
  face first targets
end

to go-to-blackboard [blackboard-patches]
  set targets lput one-of blackboard-patches targets
  set blackboard-time-in-ticks (random-exponential 5) * (60 / tick-duration-in-seconds)
  face first targets
end

to return-from-blackboard
  set targets lput desk targets
  face first targets
end

to go-to-bathroom [bathroom-floor bathroom-name]
  set toilet "Wait"

  if classroom?
    [ set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets ]

  if gym-hour?
    [ set targets lput one-of patches with [ entrance? and gym? ] targets ]

  if breed != students and floor-idx > 1
    [ set targets lput one-of patches with [ stair? and floor-number = [floor-idx] of myself ] targets ]

  set targets lput one-of patches with [ entrance? and floor-number = bathroom-floor and room-name = bathroom-name ] targets
  set targets lput one-of patches with [ floor-number = bathroom-floor and room-name = bathroom-name and not toilet? ] targets
  face first targets
end

to go-to-toilet [bathrooms-floor ]
  set toilet one-of bathrooms-floor
  set targets lput toilet targets
  set toilet-time-in-ticks (random-exponential 5) * (60 / tick-duration-in-seconds)
  ask toilet [ set occupied? true ]
  face first targets
end

to return-from-bathroom [bathroom-floor bathroom-name]
  ask toilet [ set occupied? false ]
  set targets lput one-of patches with [ entrance? and floor-number = bathroom-floor and room-name = bathroom-name ] targets

  ifelse gym-hour?
    [
      set targets lput one-of patches with [ entrance? and gym? ] targets
      set targets lput one-of patches with [ gym? ] targets
    ]
    [
      set floor-idx get-floor-by-classroom classroom

      if breed != students and floor-idx > 1
        [ set targets lput one-of patches with [ stair? and floor-number = 1 ] targets ]

      set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
      set targets lput desk targets
    ]

  set toilet []
  face first targets
end

to go-to-principal [g principal-patches]
  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets

  if floor-idx > 1
    [ set targets lput one-of patches with [ stair? and floor-number = [floor-idx] of myself ] targets ]

  set floor-idx 1
  set targets lput one-of patches with [ entrance? and principal-office? ] targets
  set targets lput one-of principal-patches targets
  set principal-time-in-ticks item g remain-time-for-lesson-in-ticks
  ask last targets [ set occupied? true ]
  face first targets
end

to return-from-principal
  set targets lput one-of patches with [ entrance? and principal-office? ] targets
  set floor-idx get-floor-by-classroom classroom

  if floor-idx > 1
    [ set targets lput one-of patches with [ stair? and floor-number = 1 ] targets ]

  set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets
  set targets lput desk targets
  ask patch-here [ set occupied? false ]
  face first targets
end

to set-targets-end-school
  ifelse gym?
    [
      set targets lput one-of patches with [ entrance? and gym? ] targets
      ask turtles with [ gym-hour? ]
        [ set gym-hour? false ]
    ]
    [
      set targets lput one-of patches with [ entrance? and room-name = [classroom] of myself ] targets

      if floor-idx > 1
        [ set targets lput one-of patches with [ stair? and floor-number = [floor-idx] of myself ] targets ]

      set floor-idx 1
    ]

  set targets lput one-of patches with [ entrance? and outdoor? ] targets

  let next-classroom classroom

  if breed = teachers
    [ set next-classroom first item (day mod 5) personal-classrooms-scheduling ]

  let staggered-condition (member? breed list teachers students and next-classroom != "-")

  ifelse staggered-admissions? and
         staggered-condition
    [
      let init-patch no-patches

      ask one-of patches with [ outdoor? and room-name = next-classroom ]
        [ set init-patch one-of patches in-radius 5 ]
      set targets lput init-patch targets
    ]
    [ set targets lput (one-of patches with [ not entrance? and outdoor? ]) targets ]

  face first targets
end

;Utilities
to read-file-classrooms-scheduling-and-gym-teachers
  let line []

  ifelse staggered-admissions?
    [ file-open "Utils/StaggeredClassroomsScheduling.txt" ]
    [ file-open "Utils/ClassroomsScheduling.txt" ]

  set classrooms-scheduling []

  while [not file-at-end?]
    [
      set line file-read
      set classrooms-scheduling lput line classrooms-scheduling
    ]

  file-close


  file-open "Utils/GymTeachers.txt"

  set gym-teachers []

  while [not file-at-end?]
    [ set gym-teachers lput file-read gym-teachers ]

  file-close
end

to-report get-x-desks [starting-classroom-x]
  ifelse students-per-classroom <= 18
    [ report (list (starting-classroom-x + 3) (starting-classroom-x + 6) (starting-classroom-x + 9)) ]
    [ report (list (starting-classroom-x + 3) (starting-classroom-x + 5) (starting-classroom-x + 7) (starting-classroom-x + 9)) ]
end

to-report get-x-chairs [starting-classroom-x]
  ifelse students-per-classroom <= 18
    [ report (list (starting-classroom-x + 4) (starting-classroom-x + 7) (starting-classroom-x + 10)) ]
    [ report (list (starting-classroom-x + 4) (starting-classroom-x + 6) (starting-classroom-x + 8) (starting-classroom-x + 10)) ]
end

to-report get-num-teachers
  let maximum 0

  set effective-classrooms-scheduling []
  set effective-teachers-flat []

  foreach classrooms-scheduling
    [
      class -> if one-of patches with [room-name = first class] != nobody
                 [ set effective-classrooms-scheduling lput class effective-classrooms-scheduling ]
    ]

  let effective-classrooms-scheduling-flat []

  foreach effective-classrooms-scheduling
    [
      class -> foreach but-first class
                 [
                   sday -> foreach sday [ lesson -> set effective-classrooms-scheduling-flat lput lesson effective-classrooms-scheduling-flat ]
                 ]
    ]

  set effective-teachers-flat remove-duplicates effective-classrooms-scheduling-flat

  report length effective-teachers-flat
end

to create-personal-classrooms-scheduling
  let name ""
  let day-num 0
  let lesson-num 0

  foreach effective-classrooms-scheduling
    [
      class -> set name first class
               set day-num 0

               foreach but-first class
                 [
                   sday -> set lesson-num 0

                           foreach sday
                             [
                               lesson -> ask teachers with [ teacher-idx = lesson ]
                                           [
                                             ifelse num-groups = 2 and [staggered-group] of one-of students with [ classroom = name ] = 1
                                               [ set personal-classrooms-scheduling replace-item day-num personal-classrooms-scheduling (replace-item (lesson-num + 1) (item day-num personal-classrooms-scheduling) name) ]
                                               [ set personal-classrooms-scheduling replace-item day-num personal-classrooms-scheduling (replace-item lesson-num (item day-num personal-classrooms-scheduling) name) ]
                                           ]

                                         set lesson-num lesson-num + 1
                             ]

                           set day-num day-num + 1
                 ]
    ]

  let lesson ""
  let other-lesson-num 0

  ask teachers
    [
      set day-num 0
      foreach personal-classrooms-scheduling
        [
          sday -> set lesson-num 0
                  while [lesson-num < length sday]
                    [
                      set lesson item lesson-num sday

                      if lesson != "-"
                        [
                          set other-lesson-num lesson-num + 1

                          while [other-lesson-num < length sday and
                                 item other-lesson-num sday = "-"]
                            [ set other-lesson-num other-lesson-num  + 1 ]

                          if other-lesson-num < length sday and
                             other-lesson-num > lesson-num + 1
                            [
                              while [(lesson-num + 1) < other-lesson-num]
                                [
                                  set personal-classrooms-scheduling replace-item day-num personal-classrooms-scheduling (replace-item (lesson-num + 1) (item day-num personal-classrooms-scheduling) "TR")
                                  set lesson-num lesson-num + 1
                                ]
                            ]

                        ]

                      set lesson-num lesson-num + 1
                    ]

                  set day-num day-num + 1

                  if first-day-of-work = 0 and
                     remove "-" (item (day-num - 1) personal-classrooms-scheduling) != []
                    [ set first-day-of-work day-num ]
        ]
    ]


  ask teachers with [ member? teacher-idx gym-teachers ]
    [ set gym-teacher? true ]
end

to-report get-floor-by-classroom [name]
  let idx 1

  if first name = "2"
    [ set idx 2 ]

  if first name = "3"
    [ set idx 3 ]

  report idx
end

to-report final-time
  let final-hour 13
  let final-minute 40

  if lesson-duration-in-minutes = 60
    [
      set final-hour 14
      set final-minute 40
    ]

  if staggered-admissions?
    [
      ifelse lesson-duration-in-minutes = 60
      [
        set final-hour 15
        set final-minute 40
      ]
      [
        set final-hour 14
        set final-minute 30
      ]
    ]

  report list final-hour final-minute
end

to-report stop-day
  let ft final-time
  let final-hour first ft
  let final-minute last ft

  report hour = final-hour and minute = final-minute and count turtles with [ not hidden? and cumulative-quanta-inhaled != 0 ] = 0
end

to-report get-num-days
  let num-days 1

  if school-day != 0 and
     school-day mod 5 = 0
    [
       set weekend? true
       set num-days 3
    ]
	
	report num-days
end

to reset-school-clock
  set day day + 1
  set hour starting-hour
  set minute starting-minute
  set second starting-second
end

to update-school-clock
  if second >= 60 - tick-duration-in-seconds
    [
      if minute = 59
        [ set hour hour + 1 ]

      set minute (minute + 1) mod 60
    ]

  set second (second + tick-duration-in-seconds) mod 60
end

;THIS FUNCTION NEED A REVIEW IF NEEDED!
;to create-supply-teacher
;  hatch-teachers 1
;    [
;      set color lime - 3
;
;      set hidden? true
;
;      set num-teachers num-teachers + 1
;      set num-agents num-agents + 1
;      set num-susceptible num-susceptible + 1
;      set remain-infected-days 0
;
;      ifelse random 100 < prob-old-teachers * 100
;        [ set age-group "Old" ]
;        [ set age-group "Regular" ]
;
;      set queue 0
;      set queue-position -1
;
;      set temperature-already-measured? false
;
;      set susceptible? true
;      set exposed? false
;      set infected? false
;      set quarantined? false
;      set supply? true
;
;      let next-classroom first item (day mod 5) personal-classrooms-scheduling
;
;      let staggered-condition next-classroom != "-"
;
;      ifelse staggered-admissions? and
;             staggered-condition
;        [
;          let init-patch no-patches
;
;          ask one-of patches with [ outdoor? and room-name = next-classroom ]
;            [ set init-patch one-of patches in-radius 5 ]
;          setxy [pxcor] of init-patch [pycor] of init-patch
;        ]
;        [ setxy ((random max-pxcor / 4.5 + max-pxcor / 4 * 3)) random max-pycor / 2 ]
;    ]
;end
;
;THIS FUNCTION NEED A REVIEW IF NEEDED!
;to create-supply-janitors
;  hatch-janitors 1
;    [
;      set color lime - 3
;
;      set hidden? true
;
;      set num-school-janitors num-school-janitors + 1
;      set num-agents num-agents + 1
;      set num-susceptible num-susceptible + 1
;      set remain-infected-days 0
;
;      ifelse random 100 < prob-old-teachers * 100
;        [ set age-group "Old" ]
;        [ set age-group "Regular" ]
;
;      set queue 0
;      set queue-position -1
;
;      set susceptible? true
;      set exposed? false
;      set infected? false
;      set quarantined? false
;      set supply? true
;
;      setxy ((random max-pxcor / 4.5 + max-pxcor / 4 * 3)) random max-pycor / 2
;    ]
;end
;
;THIS FUNCTION NEED A REVIEW IF NEEDED!
;to copy-teacher [supply-teacher infected-teacher-who]
;  let infected-teacher teachers with [who = infected-teacher-who]
;  let supply-desk desk
;  let supply-classroom classroom
;  let supply-floor-idx floor-idx
;  let supply-staggered-group staggered-group
;  let supply-gym-hour? gym-hour?
;  let supply-targets targets
;  let supply-gym-teacher? gym-teacher?
;  let supply-teacher-idx teacher-idx
;  let supply-personal-classrooms-scheduling personal-classrooms-scheduling
;  let supply-day-scheduling day-scheduling
;
;
;  ask teachers with [ who = supply-teacher ]
;    [
;      set queue 0
;      set queue-position -1
;
;      set temperature-already-measured? false
;
;      set susceptible? true
;      set exposed? false
;      set infected? false
;      set quarantined? false
;      set supply? true
;
;      set desk supply-desk
;      set classroom supply-classroom
;      set floor-idx supply-floor-idx
;
;      set staggered-group supply-staggered-group
;
;      set gym-hour? supply-gym-hour?
;
;      set targets supply-targets
;
;      set gym-teacher? supply-gym-teacher?
;
;      set teacher-idx supply-teacher-idx
;
;      set personal-classrooms-scheduling supply-personal-classrooms-scheduling
;      set day-scheduling supply-day-scheduling
;    ]
;end
;
;THIS FUNCTION NEED A REVIEW IF NEEDED!
;to copy-janitors [supply-janitors infected-janitors-who]
;  let infected-janitors janitors with [who = infected-janitors-who]
;  let supply-desk desk
;  let supply-classroom classroom
;  let supply-floor-idx floor-idx
;  let supply-staggered-group staggered-group
;  let supply-targets targets
;
;  ask janitors with [ who = supply-janitors ]
;    [
;      set queue 0
;      set queue-position -1
;
;      set susceptible? true
;      set exposed? false
;      set infected? false
;      set quarantined? false
;      set supply? true
;
;      set desk supply-desk
;      set classroom supply-classroom
;      set floor-idx supply-floor-idx
;
;      set staggered-group supply-staggered-group
;
;      set targets supply-targets
;    ]
;end

to reset-supply-teacher
  set classroom "-"
  set floor-idx 1

  set staggered-group -2

  set gym-hour? false

  set teacher-idx -1

  set personal-classrooms-scheduling []
  set day-scheduling []
end

;Print function
to print-day-results
  if day <= days-of-simulation
    [
      file-open word (word (word results-dir-name "/result") seedRun) ".txt"

      if day = 0
        [ file-print (word "day\tseedRun\tsusceptible\texposed\tinfected\tremoved\t"
                      "susceptible-in-quarantine\texposed-in-quarantine\tinfected-in-quarantine\tremoved-in-quarantine\t"
                      "susceptible-in-quarantine-external-1\texposed-in-quarantine-external-1\tinfected-in-quarantine-external-1\tremoved-in-quarantine-external-1\t"
                      "susceptible-in-quarantine-external-2\texposed-in-quarantine-external-2\tinfected-in-quarantine-external-2\tremoved-in-quarantine-external-2\t"
                      "num-of-screened-students\tnum-of-screened-students-external-1\tnum-of-screened-students-external-2\t"
                      "num-of-positive-students\tnum-of-positive-students-external-1\tnum-of-positive-students-external-2\t"
                      "num-vaccinated-susceptible\tnum-vaccinated-exposed\tnum-vaccinated-infected\tnum-vaccinated-removed\t"
                      "num-vaccinated-susceptible-in-quarantine\tnum-vaccinated-exposed-in-quarantine\tnum-vaccinated-infected-in-quarantine\tnum-vaccinated-removed-in-quarantine\t"
                      "num-vaccinated-susceptible-in-quarantine-external-1\tnum-vaccinated-exposed-in-quarantine-external-1\tnum-vaccinated-infected-in-quarantine-external-1\tnum-vaccinated-removed-in-quarantine-external-1\t"
                      "num-vaccinated-susceptible-in-quarantine-external-2\tnum-vaccinated-exposed-in-quarantine-external-2\tnum-vaccinated-infected-in-quarantine-external-2\tnum-vaccinated-removed-in-quarantine-external-2\t"
                      "num-infected-outside\tclassroom-in-quarantine\tnum-of-classroom-in-quarantine\tclassroom-with-at-least-one-infected") ]
      let classroom-with-at-least-one-infected count patches with [ entrance? and member? room-name classroom-name and count students with [ infected? and classroom = [room-name] of myself ] > 0 ]

      file-type day file-type "\t" file-type seedRun file-type "\t" file-type num-susceptible file-type "\t" file-type num-exposed file-type "\t" file-type num-infected file-type "\t" file-type num-removed file-type "\t"
      file-type num-susceptible-in-quarantine file-type "\t" file-type num-exposed-in-quarantine file-type "\t" file-type num-infected-in-quarantine file-type "\t" file-type num-removed-in-quarantine file-type "\t"
      file-type num-susceptible-in-quarantine-external-1 file-type "\t" file-type num-exposed-in-quarantine-external-1 file-type "\t"
      file-type num-infected-in-quarantine-external-1 file-type "\t" file-type num-removed-in-quarantine-external-1 file-type "\t"
      file-type num-susceptible-in-quarantine-external-2 file-type "\t" file-type num-exposed-in-quarantine-external-2 file-type "\t"
      file-type num-infected-in-quarantine-external-2 file-type "\t" file-type num-removed-in-quarantine-external-2 file-type "\t"
      file-type num-of-screened-students file-type "\t" file-type num-of-screened-students-external-1 file-type "\t" file-type num-of-screened-students-external-2 file-type "\t"
      file-type num-of-positive-students file-type "\t" file-type num-of-positive-students-external-1 file-type "\t" file-type num-of-positive-students-external-2 file-type "\t"
      file-type num-vaccinated-susceptible file-type "\t" file-type num-vaccinated-exposed file-type "\t" file-type num-vaccinated-infected file-type "\t" file-type num-vaccinated-removed file-type "\t"
      file-type num-vaccinated-susceptible-in-quarantine file-type "\t" file-type num-vaccinated-exposed-in-quarantine file-type "\t"
      file-type num-vaccinated-infected-in-quarantine file-type "\t" file-type num-vaccinated-removed-in-quarantine file-type "\t"
      file-type num-vaccinated-susceptible-in-quarantine-external-1 file-type "\t" file-type num-vaccinated-exposed-in-quarantine-external-1 file-type "\t"
      file-type num-vaccinated-infected-in-quarantine-external-1 file-type "\t" file-type num-vaccinated-removed-in-quarantine-external-1 file-type "\t"
      file-type num-vaccinated-susceptible-in-quarantine-external-2 file-type "\t" file-type num-vaccinated-exposed-in-quarantine-external-2 file-type "\t"
      file-type num-vaccinated-infected-in-quarantine-external-2 file-type "\t" file-type num-vaccinated-removed-in-quarantine-external-2 file-type "\t"
      file-type num-infected-outside file-type "\t" file-type classrooms-in-quarantine file-type "\t" file-type length classrooms-in-quarantine file-type "\t" file-print classroom-with-at-least-one-infected

      file-close
    ]
end

;Stop condition
to-report stop-condition
  let ft final-time
  let final-hour first ft
  let final-minute last ft

  report day > days-of-simulation
end
@#$#@#$#@
GRAPHICS-WINDOW
277
10
1895
689
-1
-1
10.0
1
8
1
1
1
0
0
0
1
0
160
0
66
1
1
1
ticks
30.0

BUTTON
120
11
193
44
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
196
11
269
44
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
9
121
270
154
students-per-classroom
students-per-classroom
16
24
20.0
1
1
NIL
HORIZONTAL

SLIDER
9
229
270
262
init-infected
init-infected
0
students-per-classroom * num-classrooms-per-floor * num-floors + num-classrooms-per-floor * num-floors * 2 + 1
1.0
1
1
NIL
HORIZONTAL

SLIDER
9
193
270
226
num-classrooms-per-floor
num-classrooms-per-floor
1
4
1.0
1
1
NIL
HORIZONTAL

SLIDER
9
157
270
190
num-floors
num-floors
1
3
3.0
1
1
NIL
HORIZONTAL

SLIDER
7
522
271
555
prob-go-bathroom
prob-go-bathroom
0
0.003
8.0E-4
0.0001
1
NIL
HORIZONTAL

SLIDER
7
558
270
591
prob-go-blackboard
prob-go-blackboard
0
0.01
6.0E-4
0.0001
1
NIL
HORIZONTAL

SLIDER
7
594
270
627
prob-go-somewhere-during-interval
prob-go-somewhere-during-interval
0.01
1
0.532
0.001
1
NIL
HORIZONTAL

SWITCH
896
799
1129
832
staggered-admissions?
staggered-admissions?
1
1
-1000

SLIDER
7
630
270
663
prob-go-principal
prob-go-principal
0
0.001
1.4E-4
0.00001
1
NIL
HORIZONTAL

SLIDER
9
315
270
348
num-groups
num-groups
1
2
1.0
1
1
NIL
HORIZONTAL

MONITOR
106
48
156
93
hour
hour
0
1
11

MONITOR
159
48
209
93
minute
minute
0
1
11

TEXTBOX
11
55
52
97
School clock
11
0.0
1

MONITOR
54
48
104
93
day
day
17
1
11

SLIDER
7
666
270
699
prob-old-teachers
prob-old-teachers
0
1
0.26
0.01
1
NIL
HORIZONTAL

SLIDER
7
740
270
773
prob-outside-contagion-young
prob-outside-contagion-young
0
0.01
0.0015
0.0001
1
NIL
HORIZONTAL

SLIDER
7
778
270
811
prob-outside-contagion-regular
prob-outside-contagion-regular
0
0.01
0.0029
0.0001
1
NIL
HORIZONTAL

TEXTBOX
11
103
92
121
Setup world
11
0.0
1

TEXTBOX
11
501
122
519
Setup probability
11
0.0
1

TEXTBOX
855
768
890
786
Flags
11
0.0
1

SLIDER
7
815
270
848
prob-outside-contagion-old
prob-outside-contagion-old
0
0.01
0.0081
0.0001
1
NIL
HORIZONTAL

CHOOSER
1376
708
1561
753
mask-type
mask-type
"no mask" "surgical" "ffp2"
1

CHOOSER
1132
708
1373
753
ventilation-type-h-1
ventilation-type-h-1
"no ventilation" 0.3 1 3 5 10 20
3

SLIDER
7
703
270
736
prob-old-janitors
prob-old-janitors
0
1
0.59
0.01
1
NIL
HORIZONTAL

CHOOSER
896
708
1129
753
temperature-measurement
temperature-measurement
"no measurement" "by hand" "termoscanner"
0

TEXTBOX
785
722
894
751
Countermeasures
11
0.0
1

SLIDER
9
387
270
420
mean-infection-duration-in-days
mean-infection-duration-in-days
5
20
7.0
1
1
NIL
HORIZONTAL

SLIDER
9
351
270
384
mean-incubation-duration-in-days
mean-incubation-duration-in-days
1
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
342
790
545
823
run#
run#
1
1000
1.0
1
1
NIL
HORIZONTAL

SLIDER
9
460
270
493
dad-%
dad-%
0
100
0.0
1
1
NIL
HORIZONTAL

SWITCH
1133
800
1372
833
spaced-desks?
spaced-desks?
0
1
-1000

MONITOR
212
48
269
93
NIL
second
17
1
11

SWITCH
896
836
1129
869
interval-in-front-of-classroom?
interval-in-front-of-classroom?
0
1
-1000

SLIDER
1568
708
1753
741
fraction-of-population-wearing-mask
fraction-of-population-wearing-mask
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
342
755
545
788
days-of-simulation
days-of-simulation
1
100
35.0
1
1
NIL
HORIZONTAL

CHOOSER
9
266
270
311
init-infected-type
init-infected-type
"anyone" "students" "teachers" "principals" "staff"
1

CHOOSER
342
706
545
751
lesson-duration-in-minutes
lesson-duration-in-minutes
50 60
0

TEXTBOX
288
722
343
741
Other parameters
11
0.0
1

SWITCH
1378
800
1564
833
outside-contagion?
outside-contagion?
1
1
-1000

SLIDER
896
1043
1034
1076
screening-adhesion-%
screening-adhesion-%
0
100
100.0
1
1
NIL
HORIZONTAL

SLIDER
9
423
270
456
num-of-quarantine-days
num-of-quarantine-days
7
21
14.0
1
1
NIL
HORIZONTAL

SWITCH
896
872
1129
905
vaccinated-teachers?
vaccinated-teachers?
0
1
-1000

SWITCH
1380
838
1564
871
vaccinated-principals?
vaccinated-principals?
0
1
-1000

SWITCH
1379
872
1564
905
vaccinated-janitors?
vaccinated-janitors?
0
1
-1000

SWITCH
1133
836
1373
869
external-screening?
external-screening?
0
1
-1000

CHOOSER
896
948
1372
993
screening-policy
screening-policy
"no screening" "all every week" "1/4 of the class every week, in rotation" "1/4 of the class every week, in rotation, spread over two days of the week"
3

TEXTBOX
829
962
897
980
Screening
11
0.0
1

CHOOSER
896
996
1034
1041
first-day-of-week
first-day-of-week
"monday" "tuesday" "wednesday" "thursday" "friday"
2

CHOOSER
1039
996
1178
1041
second-day-of-week
second-day-of-week
"monday" "tuesday" "wednesday" "thursday" "friday"
4

SLIDER
7
852
270
885
prob-external-screening-1
prob-external-screening-1
0
0.1
0.003
0.0001
1
NIL
HORIZONTAL

SLIDER
7
887
270
920
prob-external-screening-2
prob-external-screening-2
0
0.1
0.0075
0.0001
1
NIL
HORIZONTAL

SLIDER
342
826
545
859
tick-duration-in-seconds
tick-duration-in-seconds
4
60
60.0
4
1
NIL
HORIZONTAL

INPUTBOX
552
706
755
789
results-dir-name
Results
1
0
String

SLIDER
342
863
545
896
vaccine-efficacy
vaccine-efficacy
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
896
909
1130
942
fraction-of-vaccinated-teachers
fraction-of-vaccinated-teachers
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
1380
909
1564
942
fraction-of-vaccinated-janitors
fraction-of-vaccinated-janitors
0
1
1.0
0.01
1
NIL
HORIZONTAL

SLIDER
1135
909
1373
942
fraction-of-vaccinated-students
fraction-of-vaccinated-students
0
1
1.0
0.01
1
NIL
HORIZONTAL

SWITCH
1135
873
1373
906
vaccinated-students?
vaccinated-students?
1
1
-1000

SWITCH
896
760
1128
793
whole-classroom-quarantined?
whole-classroom-quarantined?
1
1
-1000

SLIDER
1135
763
1373
796
num-infected-needed-to-quarantine-whole-classroom
num-infected-needed-to-quarantine-whole-classroom
1
3
2.0
1
1
NIL
HORIZONTAL

SLIDER
1378
763
1563
796
number-of-after-days-special-swab
number-of-after-days-special-swab
3
10
5.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
## INTRODUCTION
Many governments enforced physical distancing measures to control the spread of COVID-19 to avoid the collapse of fragile and overloaded health care systems. Following the physical distancing measures, the closures of schools seemed unavoidable to control and reduce the transmission of the pathogen, given the potentially high-risk settings of these environments. Nevertheless, leaving the closure of schools as an extreme and last resource is a top priority of governments, therefore different non-pharmaceutical interventions in the school settings were implemented to reduce the risk of transmission. Through a detailed Agent-Based Model simulation experiment [1, 5], we study the efficacy of active surveillance strategies in the school environment. Simulations settings employed in the experiments provide hypothetical although realistic scenarios which allow us to identify the most suitable control strategy according to the viral circulation period to avoid massive school closures. The significance of risk reduction through the policies assessed in this work is relevant for public health authorities and school administrators.

## WHAT IS IT?

This is an Agent-Based Model (ABM), developed in the multi-agent programmable modeling environment NetLogo version 6.2.0 [2], to study the spread of COVID-19 infections within an explanatory scholastic environment, and to evaluate in such an environment the effectiveness of non-pharmaceutical interventions (NPIs), such as distancing requirements, screening testing, and environment ventilation.
The model components are:

* The environment including both physical spaces and social contact structure of the population;
* The COVID-19 progression model;
* The NPIs’ logic modeled to contain the COVID-19 spread.

The modeled environment is a school constituted of at most 12 classrooms (arranged on three floors), shared spaces (i.e. entrance, gym, hallways, bathrooms, stairs, medical room, teachers’ office, and principal’s office). In detail, each floor consists of one hallway that connects all the rooms and one bathroom only for the students. The school entrance, the medical room, the gym, the principal’s office, the teachers’ office and the teachers’ bathroom are on the first floor. Moreover, each classroom is characterized by twenty desks (rightly distanced from each other), one teacher desk, and the blackboard.

## HOW IT WORKS
There are four different types of agents: _students, teachers, principal and janitors_.
In particular:

* Students can go to their classroom, to the students' bathroom on the same floor of their classroom, to the principal's office, to the gym, to the hallways, etc.
* Teachers can go to the classrooms, to the teacher's room, to the teachers' bathroom on the ground floor, to the hallways, etc.
* Principal can go to the principal's office, to the teachers' bathroom on the ground floor, to the hallways etc.
* Janitors can go to the medical room, to the teachers' bathroom, to che hallways etc.

There are two different contagion models:

* Aerosol [3]: accumulation of quanta concentration in the main places and of quanta inhaled for each agent. Type of ventilation used: 3 ACH (Air Changes per Hour)<sup>1</sup>. 
* Contact [4]: accumulation of the contact time among a susceptible agent and an infected one. We considered a contact area of 2.1 * 2.1 m<sup>2</sup>}.

<sup>1</sup> Air Changes per Hour (ACH) means that in 1 hour 300.000 L (or analogous 300 m<sup>2</sup>) of external air are entered into the considere room.

## HOW TO USE IT
To run a configuration you need to create a configuration file (with .conf extension) specifying the values to assign for each (or for some) parameters (described below). In the *ExampleOfConfigurationFile* directory you can find some examples of configuration files. After that, you can run the configuration in this way:
```
./start.sh ConfigurationFileName NumberOfThreads
```
For example:
```
./start.sh ExampleOfConfigurationFile/Example1.conf 24
```

There are lots of parameters in this model. Here I describe the parameters that you can modify in the Interface Tab:

* students-per-classroom: number of students for each classroom.
* num-floors: number of school's floors.
* num-classrooms-per-floor: number of classrooms for each floor. The total number of classrooms is equal to num-floors * num-classrooms-per-floor (minimum 1, maximum 12).
* init-infected: initial number of infected agents.
* init-infected-type: the init-infected will be of this type (anyone, students, teachers, principals or janitors).
* num-groups: number of groups in which the classrooms are divided (1 not staggered admissions, 2 staggered admissions).
* mean-incubation-duration-in-days: average number of incubation days.
* mean-infection-duration-in-days: average number of infection days.
* num-of-quarantine-days: number of quarantine days.
* dad-%: percentage of distance learning.
* prob-go-bathroom: probability to go to the bathroom.
* prob-go-blackboard: probability to go to the blackboard.
* prob-go-somewhere-during-interval: probability to go somewhere during the interval.
* prob-go-principal: probability to go to the principal's office.
* prob-old-teachers: probability that a teacher belongs to the _old_ category.
* prob-old-janitor: probability that a janitor belongs to the _old_ category.
* prob-outside-contagion-young: probability that an agent that belongs to the _young_ category gets the infection outside the school.
* prob-outside-contagion-regular: probability that an agent that belongs to the _regular_ category gets the infection outside the school.
* prob-outside-contagion-old: probability that an agent that belongs to the _old_ category gets the infection outside the school.
* prob-external-screening-1: probability to swab a student outside the school because this student follows activities that involve screening campaings.
* prob-external-screening-2: probability to swab an infected students outside the school.
* lesson-duration-in-minutes: duration of a single lesson in minutes.
* days-of-simulation: number of simulation days for each execution of the simulator.
* run#: unique identifier of the running execution.
* tick-duration-in-seconds: NetLogo temporal tick.
* results-dir-name: name of the results' directory.
* temperature-measurement: temperature measurement type (at the entrance).
* ventilation-type-h-1: ventilation type implemented in all rooms but not in the hallways.
* mask-type: mask type used by agents.
* fraction-of-population-wearing-mask: fraction of all agents that use the mask.
* whole-classroom-quarantined?: we can use two diffentent _quarantine_ policies:
	* First, if we find an infected student in a classroom, we put the whole classroom in quarantine.
	* Second, if we find an infected student in a classroom, we put only this student in quarantine and we swab all the other students in the same classroom. If we find other num-infected-needed-to-quarantine-whole-classroom - 1 infected students we put the whole classroom in quarantine, otherwise we'll swab again all the other students in the same classroom after number-of-after-days-special-swab days. Again, if we find other num-infected-needed-to-quarantine-whole-classroom - 1 infected we put the whole classroom in quarantine.
* num-infected-needed-to-quarantine-whole-classroom: number of infected students needed to quarantine the whole classroom with the second _quarantine_ policy.
* number-of-after-days-special-swab: number of days after that, with the second _quarantine_ policy, we swab again all the other students in the same classroom of the infected student that we found.
* staggered-admissions?: staggered admissions (with num-groups groups).
* spaced-desks?: spaced desks (social distancing).
* outside-contagion?: possibility to get the infection outside the school.
* interval-in-front-of-classroom?: possibility to go at most in front of their classroom during the interval and not elsewhere (the agents can always go to the bathroom).
* external-screening?: external screening (outside tha school).
* vaccinated-teachers?: vaccinated teachers (immunized).
* vaccinated-principals?: vaccinated principals (immunized).
* vaccinated-janitors?: vaccinated janitors (immunized).
* fraction-of-vaccinated-students: fraction of vaccinated students.
* fraction-of-vaccinated-teachers: fraction of vaccinated teachers.
* fraction-of-vaccinated-janitors: fraction of vaccinated janitors.
* vaccine-efficacy: vaccine efficacy for vaccinated subjects.
* screening-policy: infection control stategy (or screening policy); we consider four different screening policies:
	* A1: all every week
	* D1: 1/4 of the class every week, in rotation
	* D2: 1/4 of the class every week, in rotation, spread over two days of the week
	* W0: no screening
* first-day-of-week: day of the week on which school's screening takes place; In the case of D2 policy, one half of the group is swabbed on this day.
* second-day-of-week: parameter used in the case of the D2 policy; the other half of the group is swabbed on this day.
* screening-adhesion-%: percentage of students' adhesion to the screening campaign.

Each run produce an output file and for each day we get the following information:

* day
* seedRun
* susceptible
* exposed
* infected
* removed
* susceptible-in-quarantine
* exposed-in-quarantine
* infected-in-quarantine
* removed-in-quarantine
* susceptible-in-quarantine-external-1
* exposed-in-quarantine-external-1
* infected-in-quarantine-external-1
* removed-in-quarantine-external-1
* susceptible-in-quarantine-external-2
* exposed-in-quarantine-external-2
* infected-in-quarantine-external-2
* removed-in-quarantine-external-2
* num-of-screened-students
* num-of-screened-students-external-1
* num-of-screened-students-external-2
* num-of-positive-students
* num-of-positive-students-external-1
* num-of-positive-students-external-2
* num-vaccinated-susceptible
* num-vaccinated-exposed
* num-vaccinated-infected
* num-vaccinated-removed
* num-vaccinated-susceptible-in-quarantine
* num-vaccinated-exposed-in-quarantine
* num-vaccinated-infected-in-quarantine
* num-vaccinated-removed-in-quarantine
* num-vaccinated-susceptible-in-quarantine-external-1
* num-vaccinated-exposed-in-quarantine-external-1
* num-vaccinated-infected-in-quarantine-external-1
* num-vaccinated-removed-in-quarantine-external-1
* num-vaccinated-susceptible-in-quarantine-external-2
* num-vaccinated-exposed-in-quarantine-external-2
* num-vaccinated-infected-in-quarantine-external-2
* num-vaccinated-removed-in-quarantine-external-2
* num-infected-outside
* classroom-in-quarantine
* num-of-classroom-in-quarantine
* classroom-with-at-least-one-infected

## EXTERNAL INPUT
The model needed some external input files inside a _Utils_ directory:

* *Seed.txt*: this file contains the seed.
* *ClassroomsScheduling.txt*: this file contains the teachers' scheduling on the five weekly days; each teacher has an associated identifier (it's important to not overlap the teachers between different classroom in the same hour). It's necessary to specify the scheduling for each interested classroom and for each day there must be six lessons.
* *StaggeredClassroomsScheduling.txt*: this file contains the teachers' scheduling in the case of staggered admissions.
* *GymTeachers.txt*: this file contains the identifier of the gym teachers.

## EXTENDING THE MODEL
* Fix the measure-temperature function
* Fix the create-supply-teacher function
* Fix the create-supply-janitor function
* Fix the copy-teacher function
* Fix the copy-janitor function
* Introduce some features such as:
	* Possibility of reinfection

## REFERENCES
[1] Daniele Baccega. _SchoolSEIRModel_. _2021_. URL: https://gitlab.com/danielebaccega/schoolseirmodel.

[2] Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

[3] Savvas Gkantonas et al. _airborne.cam: a risk calculator of SARSCoV-2 aerosol transmission under well-mixed ventilation conditions_. _2021_. URL: https://airborne.cam.

[4] Nicolas Hoertel et al. _«A stochastic agent-based model of the SARS-CoV-2 epidemic in France»_. In: _Nature medicine 26.9 (2020)_, pp. 1417–1421.

[5] PAPER JASS

## COPYRIGHT AND LICENSE

Copyright Daniele Baccega, Marco Beccuti, Paolo Castagno, Simone Pernice, Matteo Sereno, Pietro Terna

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

tree pine
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -7500403 true true 150 240 240 270 150 135 60 270
Polygon -7500403 true true 150 75 75 210 150 195 225 210
Polygon -7500403 true true 150 7 90 157 150 142 210 157 150 7

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
