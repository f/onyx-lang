require "../program"
require "../syntax/ast"
require "../syntax/visitor"
require "./*"

module Crystal
  ThreadLocalAttributes      = %w(ThreadLocal)
  ValidGlobalAttributes      = ThreadLocalAttributes
  ValidExternalVarAttributes = ThreadLocalAttributes
  ValidClassVarAttributes    = ThreadLocalAttributes
  ValidStructDefAttributes   = %w(Packed)
  ValidDefAttributes         = %w(AlwaysInline Naked NoInline Raises ReturnsTwice Primitive)
  ValidFunDefAttributes      = %w(AlwaysInline Naked NoInline Raises ReturnsTwice CallConvention)
  ValidEnumDefAttributes     = %w(Flags)

  class Program
    # The overall algorithm for inferring a program's type is:
    # - top level (TopLevelVisitor): declare clases, modules, macros, defs and other top-level stuff
    # - check abstract defs (AbstractDefChecker): check that abstract defs are implemented
    # - type declarations (TypeDeclarationVisitor): process type declarations like `@x : Int32`
    # - instance_vars_initializers (InstanceVarsInitializerVisitor): process initializers like `@x = 1`
    # - class_vars_initializers (ClassVarsInitializerVisitor): process initializers like `@@x = 1`
    # - main: process "main" code, calls and method bodies (the whole program).
    # - check recursive structs (RecursiveStructChecker): check that structs are not recursive (impossible to codegen)
    def infer_type(node, stats = false)
      # result = Crystal.timing("Semantic (first top level - program-wide affecting pragmas)", stats) do
      #   visit_top_level_pragmas(node)
      # end
      result = Crystal.timing("Semantic (second top level)", stats) do
        visit_top_level(node)
      end
      Crystal.timing("Semantic (abstract def check)", stats) do
        check_abstract_defs
      end
      result = Crystal.timing("Semantic (type declarations)", stats) do
        visit_type_declarations(node)
      end
      result = Crystal.timing("Semantic (ivars initializers)", stats) do
        visit_instance_vars_initializers(node)
      end
      result = Crystal.timing("Semantic (cvars initializers)", stats) do
        visit_class_vars_initializers(node)
      end
      result = Crystal.timing("Semantic (main)", stats) do
        visit_main(node)
      end
      Crystal.timing("Semantic (cleanup)", stats) do
        cleanup_types
      end
      Crystal.timing("Semantic (recursive struct check)", stats) do
        check_recursive_structs
      end
      result
    end
  end

  class PropagateDocVisitor < Visitor
    @doc : String

    def initialize(@doc)
    end

    def visit(node : Expressions)
      true
    end

    def visit(node : ClassDef | ModuleDef | EnumDef | Def | FunDef | Alias | Assign)
      node.doc ||= @doc
      false
    end

    def visit(node : ASTNode)
      true
    end
  end
end
