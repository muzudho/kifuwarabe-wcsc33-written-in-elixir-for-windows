defmodule KifuwarabeWcsc33.CLI.Routes.UndoMove do
  @moduledoc """
    局面ができる
  """

  @doc """

    駒を（逆向きに）動かす

  ## Parameters

    * `pos` - ポジション（Position；局面）
  
  ## Returns

    0. ポジション（Position；局面）
  
  """
  def move(pos) do
    # 相手のターン
    opponent_turn = pos.turn

    # 最後の指し手を取得（リンクドリストなので効率が悪い）
    last_index = Enum.count(pos.moves)-1
    move = pos.moves |> elem(last_index)

    # 局面更新
    #
    # - ターン反転
    # - 指し手のリスト更新（最後の指し手を削除）
    pos = %{pos |
            turn: KifuwarabeWcsc33.CLI.Mappings.ToSengo.flip(pos.turn),
            moves: pos.moves |> List.delete_at(last_index)
          }

    pos =
      if move.drop_piece_type != nil do
        # 打った駒と、減る前の枚数
        drop_piece = KifuwarabeWcsc33.CLI.Mappings.ToPiece.from_turn_and_piece_type(pos.turn, move.drop_piece_type)
        num = pos.hand_pieces[drop_piece] + 1
        # 局面更新
        pos = %{ pos |
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

        pos
      else
        # 局面更新
        pos = %{ pos |
          # 将棋盤更新
          board: %{ pos.board |
            # 移動元マスは、動かした駒になる
            move.source => pos.board[move.destination],
            # 移動先マスは、取った駒（なければ空マス）になる
            move.destination =>
              if move.captured != nil do
                KifuwarabeWcsc33.CLI.Mappings.ToPiece.from_turn_and_piece_type(opponent_turn, move.captured)
              else
                :sp
              end
          }
        }

        pos
      end

    # 更新された局面を返す
    pos
  end
end