var Repo = React.createClass({
  getInitialState: function() {
    return {
      repo: this.props.data
    }
  },
  render: function() {
    return (
      <div>
        <span>{this.props.data.name}</span>
          <label>
            <input type="checkbox"/>
          </label>
      </div>
    );
  }
});