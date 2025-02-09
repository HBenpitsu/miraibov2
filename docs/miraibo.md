
> [!check] confirmed
> Feb 8th 2025

# Miraibo

Miraibo helps users plan and track their finances by visualizing past and future payments, making financial management easier for students and young professionals.

In this document, the abstraction of features are explained.
Note that this document does not contain detail for implementation, and does not specify the data structure.

# Index

- [Miraibo](#miraibo)
- [Index](#index)
- [Specification](#specification)
- [Planning Page](#planning-page)
  - [Calendar view Screen](#calendar-view-screen)
    - [visual image](#visual-image)
  - [Daily view Screen](#daily-view-screen)
    - [Visual Image](#visual-image-1)
  - [Ticket creation Window](#ticket-creation-window)
- [Main Page](#main-page)
- [Data Page](#data-page)
- [Utils Page](#utils-page)
- [Ticket](#ticket)
  - [Trivial or Notable Ticket](#trivial-or-notable-ticket)
  - [What ‘Ticket Belongs To’ Really Means](#what-ticket-belongs-to-really-means)
    - [Belonging Rules for Each Ticket Type](#belonging-rules-for-each-ticket-type)
  - [Where the Tickets Appear and in Which Order](#where-the-tickets-appear-and-in-which-order)
    - [Planning Page](#planning-page-1)
    - [Main Page](#main-page-1)
    - [Utils Page](#utils-page-1)
  - [Log Ticket](#log-ticket)
  - [Monitor Ticket](#monitor-ticket)
  - [Plan Ticket](#plan-ticket)
  - [Estimation Ticket](#estimation-ticket)
- [Category](#category)

# Specification

Miraibo contains four main pages:

- `Planning Page`
- `Main Page`
- `Data Page`
- `Utils Page`

Each page can be switched using a tab view.

# Planning Page

`Planning Page` allow users to edit/create/delete all kind of tickets.

`Planning Page` consists of two screens.

- `Calendar view Screen`
- `Daily view Screen`

General flow is like this:

- `Calendar view Screen`
  - Tap date
    - `Daily view Screen`
      - Tap `Ticket creation Button`
        - `Ticket creation Window`
      - Tap `Ticket`
        - `Ticket edit Window` for each type of `Ticket`.

## Calendar view Screen

The `Calendar view Screen` consists of a virtually infinite set of monthly calendar. The calendar shown in the center initially is the one containing today's date. The screen is vertically scrollable.
A monthly calendar consists of year-label, month-label and dates which is arrenged in ordinal way.
`Ticket`s on a date is reflected as a color of the date:

- noTicket(disabled color): there is no `Ticket` on the date.
- trivialTicket(secondary color): there is(are) trivial `Ticket`(s) on the date.
- notableTicket(primary color): there is(are) notable `Ticket`(s) on the date.

Each date is a button that navigates to `Daily view Screen`.

- [What 'There is a `Ticket` on a date' means?](#ticket)
- [What is a notable/trivial `Ticket`?](#trivial-or-notable-ticket)

### visual image

![[calender-sample.png]]

## Daily view Screen

`Daily view Screen` consists of a row of `Tickets Container`, `Label`, and floating `Ticket creation Button`.

`Daily view Screen` is scrollable horizontally.
`Tickets Container` is scrollable vertically.

Tapping the `Ticket creation Button` opens a modal window called the `Ticket creation Window`.

Users can edit the content of a `Ticket` by tapping it. The `Ticket edit Window` is similar to the `Ticket creation Window`, but the `Type selection Tab` is omitted.

Tapping outside the `Tickets Container` returns the screen to the `Calendar View Screen`.

### Visual Image

![[tickets-sample.png]]

## Ticket creation Window

The `Ticket creation Window` contains two widgits:

- `Ticket configuration Section`
- `Type selection Tab`

In the `Ticket creation Window`, users can create the following types of tickets:

- `Monitor Ticket`
- `Plan Ticket`
- `Estimation Ticket`

The `Type selection Tab` allows users to choose the type of ticket they want to create.

The `Ticket configuration Section` varies based on the type of ticket selected. For details for each type of tickets, check [Ticket](#ticket) section.

There are shared part, `Chips`, too: `Save button`-'Check Mark' and `Delete button`-'Cross Mark' on the top-right.

# Main Page

`Main Page` is a initial page. It displays values as user decided in Planning Page. Users can make/check the latest `Receipt Data` in this Page.

`Main Page` contains;

- `Ticket Container`
- `Log Button`

`Ticket Container` is scrollable vertically.
There are `Monitor Ticket`, `Plan Ticket` and `Log Ticket` in the container.

`Log Button` is a floating button to register `Receipt Data` into database and to make `Log Ticket`.
`Log Button` lays over `Ticket Container`.

Pressing `Log Button` opens `Log information Window`.
`Log information Window` is like `Ticket creation Window`.
But `Ticket configuration Section` for `Log Ticket` is different from any other type of tickets.

`Log information Window` collects following details:

- Item's (receipt's) category
- Supplementary information
- Registration date
- Amount of money (with notation of in/out)

User can take picture of receipt and attach it.

`Log information Window` also provide `Presets`.

`Presets` will automatically generated from history.
When a `Preset` is selected,

- Item's (receipt's) category
- Supplementary information
- notation of in/out

are automatically filled up. As default, the latest preset is selected.

When `Log Ticket` is pressed, it opens `Ticket edit Window`.
About details for `Ticket edit Window`, check [Log Ticket](#log-ticket) section.

General flow is:

- `Ticket Page`
  - Press `Log Ticket`
    - `Confirmation Dialog`
      - Press `Confirm button`
      - Press `Edit button`
        - `Ticket edit Window`
  - Press `Log Button`
    - `Log information Window`

# Data Page

`Data Page` exists to allow users to access all data dealt with this app.

`Data Page` contains:

- `Table`
- `Data im/export Button`.

`Data Page` itself is scrollable in any direction.

`Table` shows all of `Receipt Data` in a table format.
Pressing a row, user can open corresponding (log) `Tikcet edit Window`.

`Data im/export Button` is a floating button.
Pressing `Data im/export Button` opens `Data im/export Window`.

The window contains:

- `Receipt data export Button`
- `Receipt data import Button`
- `Receipt data override Button`

These features support `.csv` format for compatibility with external tools like Google Sheets.

The window also contains:

- `App data backup Button`
- `App data restore Button`

They are used to backup application data.

Raw database file `.db` and preference file `.json` are exploited from application when backup button pressed.
On the other hand, restore button calls window to load `.db` file and `.json` file.

# Utils Page

`Utils Page` contains:

- `Category controller Section`
- `Tentative monitor ticket Section`
- `Tentative estimation ticket Section`
- `Chart Section`

In `Category controller Section`, categories can be

- renamed
- created
- integrated.

`Category controller Section` provides list of categories and `Category Create Button`.

When a category is pressed, it opens `Category edit Window`.
On `Category edit Window`, users can rename the category by rewriting an inline-text form. And there are pull-down menus that show the list of categories, and an `Integration Button`.

Pressing the `Integration Button` opens a `Confirmation Dialog` which has a `Confirm Button` and a `Cancel Button`.

When the `Category Create Button` is pressed, the `Category Create Window` opens.
The `Category Create Window` merely contains an inline-text form for its name, a `Create Button`, and a `Cancel Button`.

In the `Chart Section`, users can generate:

- accumulation charts
  - that indicate the increase and decrease of the gross estate for specific categories or all categories over time.
- subtotal charts
  - which show the total amounts per month.
- A pie chart
  - that shows ratio of absolute values of target categories.

`Tentative monitor ticket Section` show the statistical information as `Monitor Ticket`s do.
`Tentative estimation ticket Section` shows the value as `Estimation Ticket` do.

Above all is folded at first, and user can expand them when they needs to do so.

# Ticket

`Ticket` appears in `Planning Page`, `Ticket Page` and `Utils Page`.

`Ticket`s are classified into four types:

- `Log Ticket`
- `Monitor Ticket`
- `Plan Ticket`
- `Estimation Ticket`

A `Ticket` is a standardized interface to present/edit information.

## Trivial or Notable Ticket

`Notable Ticket`s are following ones:

- `Plan Tickets` which are the last or the first ones of their group
- `Monitor Tickets` which are the last ones of their group
- `Estimation Tickets` which are the last or first ones of their group
- Unconfirmed `Log Tickets`.

The other tickets are all `Trivial`.

## What ‘Ticket Belongs To’ Really Means

A `Ticket` is considered to **belong** to a specific date or period based on its type and purpose. This determines when and where it appears in the `Planning Page` and other parts of the application.

### Belonging Rules for Each Ticket Type

- **Log Ticket** → Belongs to its **registration date** (the date the receipt was logged).
- **Monitor Ticket** →
    - If set to **"Until Today"** or **"Last Designated Period"**, it belongs to **all dates** up to today.
    - If set to **"Until a Designated Date"**, it belongs to **all dates before that date**.
    - If set to **"Specific Period"**, it belongs **only to that period**.
- **Plan Ticket** →
    - Appears on its **scheduled date(s)**.
    - If recurring, belongs to **all scheduled dates** in the future.
- **Estimation Ticket** →
    - Belongs to **all days** within its designated period.

This "belonging" concept ensures that tickets are visually placed where they are most relevant for financial tracking.

## Where the Tickets Appear and in Which Order

Each page displays different ticket types in a structured order for better usability.

### Planning Page

- **Order:**
    1. `Monitor Tickets`
    2. `Plan Tickets`
    3. `Estimation Tickets`
    4. `Log Tickets`
- **Where they appear:**
    - `Monitor Tickets` appear **as long as their condition applies**.
    - `Plan Tickets` appear **on their scheduled dates**.
    - `Estimation Tickets` appear **throughout their estimation period**.
    - `Log Tickets` appear **only on the date they were logged**.

### Main Page

- **Order:**
    1. `Monitor Tickets`
    2. `Plan Tickets`
    3. `Log Tickets`
- **Where they appear:**
    - `Monitor Tickets` appear **continuously** if applicable.
    - `Plan Tickets` appear **on their expected occurrence date**.
    - `Log Tickets` appear **until confirmed**, then disappear.
    - Recent `Log Tickets` (added within the last three days) appear regardless of their confirmation status.

### Utils Page

- `Monitor Tickets` appear as **Tentative Monitor Tickets**.
- `Estimation Tickets` appear as **Tentative Estimation Tickets**.

## Log Ticket

A Log Ticket allows users to confirm and edit logged `Receipt Data`. A Log Ticket contains the following details to represents `Receipt Data`:

- Item's (receipt's) category
- Supplementary information
- Registration date
- Amount of money (with notation of in/out)
- URL of the registered image (if any)
  - normally hidden and only visible in `Ticket edit Window`
  - can be updated in `Ticket edit Window`

When pressed in `Ticket Page`, `Confirmation Dialog` opens.
`Confirmation Dialog` has `Confirm button` and `Edit button`.
It automatically dismissed and disappers from `Ticket Page` in some days.

When `Confirm button` is pressed, the ticket disappears from the `Ticket Page` immediately.
When `Edit button` is pressed, the `Ticket edit Window` opens, allowing users to edit the information above.

When pressed in `Planning Page`, it opens `Ticket edit Widnow`.

The ticket `belongs` to `Registration date`.
That means, the tickets appears on the `Registration date` on the `Planning Page`.

Note that, single ticket only belongs to single category.

## Monitor Ticket

A Monitor Ticket allows users to check the situation.

Monitor Ticket has 4 Term Modes:

- Until today
- Last designated period
- Until a designated date
- Specific period

For each term-mode, there are some options.

On `Until today`:
On `Last designated period`:
On `Specific period`:

- daily average
- daily quartile average
- monthly average
- monthly quartile average
- summation

On `Until a designated date`:

- summation

For all modes and options, `Target categories` should be specified.
User can choose multiple categories and 'all' option.

Both on the `Planning Page` and on the `Ticket Page`, it opens `Ticket edit Window` when it is pressed.

On `Until today` and `Last designated period`:

Monitor Ticket `belongs` to all days, that means, the Ticket appears in all days of `Ticket Container`.

On `Specific period`:

Monitor Ticket `belongs` to the period.

On `Until a designated date`:

Monitor Ticket `belongs` to all days until the date, that means, the Ticket only appears until the date.

For `Last designated period`, there are period-options:

- week
- month
- half-year
- year

For `Specific period`, finite period should be specified.

## Plan Ticket

`Plan Ticket` basically exists for estimation. But it also omit the users' labor to register ticket by their own.

On `Planning Page`, `Plan Ticket` appears on the date to which it `belongs`.
When it pressed, `Ticket edit Window` opens.

On `Ticket Page`, its function is just like `Log Ticket`.
It automatically appears on the registered date.
When pressed, it opens `Confirmation Dialog` which has `Confirm button`,  `Edit button` and `Reject button`. When it's confirmed, it pop `Log Ticket` and disappears.
Pressing `Edit button`, of course, opens `Ticket edit Window`.
Pressing `Reject button` removes the ticket. However, it does not remove plan itself, that means, if it is repetitive schedule, it does not delete the schedule.

On `Planning Page`, it opens `Ticket edit Window` when pressed.

`Ticket edit Window` collects:

- `Category`
  - single choice
- Supplement
  - Free text (null-able)
- Amount
  - user can select income or outcome
  - does not support negative input
- Repeat Setting
  - no
  - yes
    - frequency
      - interval: e.g. every xxx day
      - week: e.g. every Monday and every Sunday
      - month: e.g. 5th day (from beginning), 3rd day (from end)
      - year: annual event
    - period
      - from: the date when the period begins or unlimited
      - until: the date when the period ends or unlimited

## Estimation Ticket

Estimation Ticket exists for auto complementary for estimation. This ticket only appears on `Planning Page`.

When it's pressed in the `Planning Page/Ticket Container`, it opens `Ticket edit Window`.

For this ticket,

- `Category`
  - multiple choice
- period
  - from: the date when the period begins or unlimited
  - until: the date when the period ends or unlimited
- display_mode
  - perDay
  - perWeek
  - perMonth
  - perYear

should be specified.

it belongs to all days of designated period.

# Category

Each `Receipt Data` should have **a single** `Category`.

`Category` is like:

- Food
- Gas
- Water
- Electricity
- Transportation
- Education Fee
- Education Materials
- Medication
- Amusement
- Furniture
- Necessities
- Other Expense
- Scholarship
- Payment
- Other Income
- Adjustment
