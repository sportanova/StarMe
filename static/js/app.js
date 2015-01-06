var App = React.createClass({
  getInitialState: function() {
    return {
    }
  },
  render: function() {
    return (
      <div>
        <Repos username={this.props.username}/>
      </div>
    );
  }
});

function StarMe() {
}

StarMe.prototype.init = function(domNode, attrs) {
  this.react = React.render(<App username={attrs.username}/>, domNode);
  return this.react;
};

StarMe.prototype.setState = function(attrs) {
  this.react.setState(attrs);
};