All classes in the `skeleton` layer reflects screen-transition of view.
Each skeleton class has:

- **Controller**s
  - Methods that modifies model (and can modify the state)
- **Presenter**s
  - Methods that provides Future(the screen would not change while displayed) or Stream(the screen can change while displayed) of **ViewModels** that have primitive or `dto`-type data, or `dto` itself.
- **Navigator**s
  - Methods that provide access to other skeleton classes.
  - Opening a new window is expressed as a method.
  - A tab is expressed as a field.
- **Action**s
  - Methods only changes the state. They do not affect the model.
  - Presenters can be affected.
- **States**

states can be inherited. Although inheritation is not expressed in interface explisitly, that should be implemented.
Inheritation is implied by the name of states.
