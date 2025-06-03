import typer

app = typer.Typer(
    name="promptcastle",
    help="CLI for managing Prompt Castle 3.0 projects and components."
)

@app.command()
def hello(name: str = "World"):
    """
    A simple greeting command.
    """
    print(f"Hello {name} from Prompt Castle CLI!")

@app.command()
def generate(template: str = typer.Option("basic", help="The template to use for generation.")):
    """
    Generates a new prompt or component based on a template.
    """
    # Placeholder for actual generation logic
    print(f"Generated prompt using template: {template}")
    print("This is a placeholder. Actual generation logic will be implemented here.")

if __name__ == "__main__":
    app() 