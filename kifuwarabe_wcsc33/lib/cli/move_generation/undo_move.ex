defmodule KifuwarabeWcsc33.CLI.MoveGeneration.UndoMove do
  @moduledoc """
    局面ができる
  """

  @doc """

    駒を（逆向きに）動かす

  ## Parameters

    * `pos` - ポジション（Position；局面）
  
  ## Returns

    0. ポジション（Position；局面）
  
  ## 雑談

    - 自殺手のときアンドゥする

  """
  def do_it(pos) do
    # 最後の要素を削除するために、インデックスを取得しておく
    last_index = Enum.count(pos.moves) - 1
    # IO.puts("last_index:#{last_index} pos.moves.length:#{pos.moves|>length()}")

    # 最後の指し手を取得（リンクドリストなので効率が悪い）
    move = pos.moves |> List.last()
    # (あれば)取った駒を取得（先後の情報無し、成りの情報付き）
    captured_pt = pos.captured_piece_types |> List.last()

    # 局面更新
    #
    # - ターン反転
    # - 指し手のリスト更新（最後の指し手を削除）
    pos = %{pos |
            turn: KifuwarabeWcsc33.CLI.Mappings.ToTurn.flip(pos.turn),
            opponent_turn: pos.turn,
            # リストの最後の要素を削除。リストのサイズを揃える
            moves: pos.moves |> List.delete_at(last_index),
            captured_piece_types: pos.captured_piece_types |> List.delete_at(last_index)
          }

    # 更新された局面を返す
    if move.drop_piece_type != nil do
      # 打った駒と、減る前の枚数
      drop_piece = KifuwarabeWcsc33.CLI.Mappings.ToPiece.from_turn_and_piece_type(pos.turn, move.drop_piece_type)
      num = pos.hand_pieces[drop_piece] + 1
      # 局面更新
      %{ pos |
        # 将棋盤更新
        board: %{ pos.board |
            # 置いた先を、空マスにする
            move.destination => :sp
          },
        # 駒台更新
        hand_pieces: %{ pos.hand_pieces |
            # 枚数を１増やす
            drop_piece => num
          }
      }

    else
      # 動かした駒が玉なら
      played_piece = if move.promote? do
          # TODO （成った駒は）成らずに戻す
          KifuwarabeWcsc33.CLI.Mappings.ToPiece.demote(pos.board[move.destination])
        else
          pos.board[move.destination]
        end

      # 局面更新
      pos = %{ pos |
        # 将棋盤更新
        board: %{ pos.board |
          # 移動元マスは、動かした駒になる
          move.source => played_piece,

          # 移動先マスは、取った駒（なければ空マス）になる
          move.destination =>
            if captured_pt != nil do
              # 取った駒種類に先後を付ける
              KifuwarabeWcsc33.CLI.Mappings.ToPiece.from_turn_and_piece_type(pos.opponent_turn, captured_pt)
            else
              :sp
            end
        }
      }

      # 局面更新
      pos =
        if played_piece == :k1 or played_piece == :k2 do
          # 玉のいるマスを（移動元マスへ）更新
          %{ pos |
            location_of_kings: %{ pos.location_of_kings |
              played_piece => move.source
            }
          }
        else
          pos
        end

      pos
    end

  end
end