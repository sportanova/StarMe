var App = React.createClass({
  getInitialState: function() {
    return {
    }
  },
  render: function() {
    return (
      <div>
        <Repos repoType='public' username="sportanova"/>
        <Repos repoType='selected' username="sportanova"/>
      </div>
    );
  }
});

function StarMe() {
  this.appExists = false;
}

StarMe.prototype.init = function(domNode, attrs) {
  this.react = React.render(<App/>, domNode);
  return this.react;
};

StarMe.prototype.setState = function(attrs) {
  this.react.setState(attrs);
};